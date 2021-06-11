Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'PasswordState-Management' {
    Describe 'Get-PasswordStateResource' {
        BeforeAll {
            $FunctionName='Get-PasswordStateResource'
            $PreferencePath='TestDrive:'
            $BaseUri = 'https://passwordstate.local'
            $APIKey='SuperSecretStuff'
            $Credential=[pscredential]::new('MyUser',(ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterTestCases = @(
                @{parameterName='Uri';Mandatory='False'}
                @{parameterName='Method';Mandatory='False'}
                @{parameterName='ContentType';Mandatory='False'}
                @{parameterName='ExtraParams';Mandatory='False'}
            )
            Mock -CommandName 'Invoke-RestMethod' -MockWith {
                $Global:TestJSON['PWSResponse']
            }
        }
        Context 'Parameter validation' {
            It 'Should have a parameter <ParameterName>' -TestCases $ParameterTestCases {
                param($ParameterName)
                (get-command $FunctionName).Parameters[$ParameterName] | Should -Not -BeNullOrEmpty
            }
            It 'Should have a parameter <parameter> with mandatory property set to <mandatory>' -TestCases $ParameterTestCases {
                param($ParameterName, $Mandatory)
                "$(((Get-Command -Name $FunctionName).Parameters[$ParameterName].Attributes | Where-Object { $_.gettype().Fullname -eq 'System.Management.Automation.ParameterAttribute'}).Mandatory)" | should -be $Mandatory
            }
        }
        Context 'Unit Tests apikey' {
            BeforeAll {
                Set-PasswordStateEnvironment -path $PreferencePath -Baseuri $BaseUri -Apikey $APIKey
            }
            AfterAll {
                Remove-Item 'TestDrive:\Passwordstate.json' -Confirm:$false -Force -ErrorAction SilentlyContinue
            }
            It 'Should return a response' {
                Get-PasswordStateResource -uri '/api/response' | Should -Not -BeNullOrEmpty
            }
        }
        Context 'Unit tests Windows authentication' {
            BeforeAll {
                Set-PasswordStateEnvironment -path $PreferencePath -Baseuri $BaseUri -WindowsAuthOnly
            }
            AfterAll {
                Remove-Item 'TestDrive:\Passwordstate.json' -Confirm:$false -Force -ErrorAction SilentlyContinue
            }
            It 'Should return a response' {
                Get-PasswordStateResource -uri '/api/response' | Should -Not -BeNullOrEmpty
            }
        }
        Context 'Unit tests Custom Credential' {
            BeforeAll {
                Set-PasswordStateEnvironment -path $PreferencePath -Baseuri $BaseUri -customcredentials $Credential
            }
            AfterAll {
                Remove-Item 'TestDrive:\Passwordstate.json' -Confirm:$false -Force -ErrorAction SilentlyContinue
            }
            It 'Should return a response' {
                Get-PasswordStateResource -uri '/api/response' | Should -Not -BeNullOrEmpty
            }
        }
    }
}