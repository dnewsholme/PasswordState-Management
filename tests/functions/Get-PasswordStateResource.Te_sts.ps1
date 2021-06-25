BeforeAll {
    if (Test-Path "$([environment]::GetFolderPath('UserProfile'))\passwordstate.json") {
        Rename-Item "$([environment]::GetFolderPath('UserProfile'))\passwordstate.json" "$([environment]::GetFolderPath('UserProfile'))\stowaway_passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
    }
    Import-Module -Name "$($PSScriptRoot)\..\..\passwordstate-management.psd1" -Force
}
AfterAll {
    Remove-Module -Name 'passwordstate-management' -ErrorAction SilentlyContinue
    if (Test-Path "$([environment]::GetFolderPath('UserProfile'))\stowaway_passwordstate.json") {
        Rename-Item "$([environment]::GetFolderPath('UserProfile'))\stowaway_passwordstate.json" "$([environment]::GetFolderPath('UserProfile'))\passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
    }
}
InModuleScope -ModuleName 'passwordstate-management' {
    Describe 'Get-PasswordStateResource' {
            BeforeAll {
            $FunctionName='Get-PasswordStateResource'
            $ProfilePath='TestDrive:'
            $BaseUri = 'https://passwordstate.local'
            $APIKey='SuperSecretStuff'
            $Credential=[pscredential]::new('MyUser',(ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $Paramattributetype='System.Management.Automation.ParameterAttribute'
            . "$($PSScriptRoot)\json\enum-jsonfiles.ps1"
        }
        Context 'Parameter validation' -Foreach @(
            @{parameterName='Uri';Mandatory='False'}
            @{parameterName='Method';Mandatory='False'}
            @{parameterName='ContentType';Mandatory='False'}
            @{parameterName='ExtraParams';Mandatory='False'}
        ) {
            It 'Should have a parameter <parameterName>' {
                (Get-Command -Name 'Get-PasswordStateResource').Parameters[$parameterName] | Should -Not -BeNullOrEmpty
            }
            It 'Should have a parameter <parameter> with mandatory property set to <mandatory>' {
                "$(((Get-Command -Name $FunctionName).Parameters[$parameterName].Attributes | Where-Object { $_.gettype().Fullname -eq $Paramattributetype}).Mandatory)" | should -be $Mandatory
            }
        }
        Context 'Unit Tests apikey' {
            BeforeAll {
                Set-PasswordStateEnvironment -Uri $BaseURI -Apikey $APIKey -path $ProfilePath | Out-Null
                Mock -CommandName 'Invoke-RestMethod' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['PWSResponse'] }
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return a response' {
                InModuleScope -ModuleName 'passwordstate-management' {
                    Get-PasswordStateResource -uri '/api/response' | Should -Not -BeNullOrEmpty
                    Should -Invoke 'Invoke-RestMethod' -Exactly -Times 1 -Scope It
                }
            }
        }
        Context 'Unit tests Windows authentication' {
            BeforeAll {
                Set-PasswordStateEnvironment -Uri $BaseURI -WindowsAuthOnly -path $ProfilePath | Out-Null
                Mock -CommandName 'Invoke-RestMethod' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['PWSResponse'] }
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return a response' {
                InModuleScope -ModuleName 'passwordstate-management' {
                    Get-PasswordStateResource -uri '/api/response' | Should -Not -BeNullOrEmpty
                    Should -Invoke 'Invoke-RestMethod' -Exactly -Times 1 -Scope It
                }
            }
        }
        Context 'Unit tests Custom Credential' {
            BeforeAll {
                Set-PasswordStateEnvironment -Uri $BaseURI -customcredentials $TestCredential -path $ProfilePath | Out-Null
                Mock -CommandName 'Invoke-RestMethod' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['PWSResponse'] }
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return a response' {
                InModuleScope -ModuleName 'passwordstate-management' {
                    Get-PasswordStateResource -uri '/api/response' | Should -Not -BeNullOrEmpty
                    Should -Invoke 'Invoke-RestMethod' -Exactly -Times 1 -Scope It
                }
            }
        }
    }
}
