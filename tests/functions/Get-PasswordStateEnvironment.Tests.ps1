Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope -ModuleName 'PasswordState-Management' {
    Describe 'Get-PasswordStateEnvironment' {
        BeforeAll {
            $FunctionName='Get-PasswordStateEnvironment'
            $PWSUri = 'https://passwordstate.local'
            $PWSCredential = [pscredential]::new('MyUser',(ConvertTo-SecureString -AsPlainText -Force -String 'VerySecurePassword'))
            $ParameterTestCases=@(
                @{ParameterName='Path';Mandatory='False'}
            )
        }
        Context 'Parameter validation' {
            It 'Should have a parameter <ParameterName>' -TestCases $ParameterTestCases {
                param($ParameterName)
                (Get-Command -Name $FunctionName).Parameters[$ParameterName] | should -Not -BeNullOrEmpty
            }
            It 'Should have a parameter <ParameterName> with Mandatory set to <Mandatory>' -TestCases $ParameterTestCases {
                param($ParameterName, $Mandatory)
                "$(((Get-Command -Name $FunctionName).Parameters[$ParameterName].Attributes | Where-Object { $_.gettype().Fullname -eq 'System.Management.Automation.ParameterAttribute'}).Mandatory)" | should -be $Mandatory
            }
        }
        Context 'Error unit testing' {
            It 'Should throw when no jsonfile can be found' {
                Remove-Item 'TestDrive:PasswordState.json' -ErrorAction SilentlyContinue -Force
                { Get-PasswordStateEnvironment -path 'TestDrive:'} | Should -Throw
            }
        }
        Context 'APIKey unit testing' {
            BeforeEach {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $PWSUri -Apikey 'KeyString'
            }
            AfterEach {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Confirm:$false -Force
            }
            It 'Should return a PasswordState Environment' {
                Get-PasswordStateEnvironment -path 'TestDrive:' | Should -Not -BeNullOrEmpty
            }
            It 'Should return a PasswordState Environment with Authentication ApiKey' {
                (Get-PasswordStateEnvironment -path 'TestDrive:').AuthType | Should -BeExactly 'APIKey'
            }
        }
        Context 'Windows Authentication unit testing' {
            BeforeEach {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $PWSUri -WindowsAuthOnly
            }
            AfterEach {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Confirm:$false -Force
            }
            It 'Should return a PasswordState Environment' {
                Get-PasswordStateEnvironment -path 'TestDrive:' | Should -Not -BeNullOrEmpty
            }
            It 'Should return a PasswordState Environment with Authentication WindowsIntegrated' {
                (Get-PasswordStateEnvironment -path 'TestDrive:').AuthType | Should -BeExactly 'WindowsIntegrated'
            }
        }
        Context 'Custom Credential unit testing' {
            BeforeEach {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $PWSUri -customcredentials $PWSCredential
            }
            AfterEach {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Confirm:$false -Force
            }
            It 'Should return a PasswordState Environment' {
                Get-PasswordStateEnvironment -path 'TestDrive:' | Should -Not -BeNullOrEmpty
            }
            It 'Should return a PasswordState Environment with Authentication WindowsCustom' {
                (Get-PasswordStateEnvironment -path 'TestDrive:').AuthType | Should -BeExactly 'WindowsCustom'
            }
        }
    }
}