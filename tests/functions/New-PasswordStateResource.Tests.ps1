Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope -ModuleName 'PasswordState-Management' {
    Describe "New-PasswordStateResource" {
        BeforeAll {
            $FunctionName='New-PasswordStateResource'
            $PreferencePath='TestDrive:'
            $BaseUri = 'https://passwordstate.local'
            $APIKey='SuperSecretStuff'
            $Credential=[pscredential]::new('MyUser',(ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterTestCases = @(
                @{parameterName='Uri';Mandatory='False'}
                @{parameterName='Method';Mandatory='False'}
                @{parameterName='Body';Mandatory='False'}
                @{parameterName='ContentType';Mandatory='False'}
                @{parameterName='ExtraParams';Mandatory='False'}
                @{parameterName='Sort';Mandatory='False'}
            )
            Mock -CommandName 'Invoke-RestMethod' -Verifiable -MockWith {
                $Global:TestJSON['PWSResponse']
            }
        }
        Context 'Parameter validation' {
            It 'Should have a parameter <ParameterName>' -TestCases $ParameterTestCases {
                param($ParameterName)
                (get-command $FunctionName).Parameters[$ParameterName] | Should -Not -BeNullOrEmpty
            }
            It 'Should have a parameter <parameterName> with mandatory property set to <mandatory>' -TestCases $ParameterTestCases {
                param($ParameterName, $Mandatory)
                "$(((Get-Command -Name $FunctionName).Parameters[$ParameterName].Attributes | Where-Object { $_.gettype().Fullname -eq 'System.Management.Automation.ParameterAttribute'}).Mandatory)" | should -be $Mandatory
            }
        }
        Context 'Unit tests for Windows authentication' {
            BeforeAll {
                Set-PasswordStateEnvironment -path $PreferencePath -Baseuri $BaseUri -WindowsAuthOnly
            }
            AfterAll {
                Remove-Item 'TestDrive:\Passwordstate.json' -Confirm:$false -Force -ErrorAction SilentlyContinue
            }
            It 'Should return a response' {
                (Invoke-Expression -Command "$($FunctionName) -uri '/api/response'" ) | Should -Not -BeNullOrEmpty
                Assert-MockCalled -CommandName 'Invoke-RestMethod' -Exactly -Times 1 -Scope It
            }
        }
    }
}
