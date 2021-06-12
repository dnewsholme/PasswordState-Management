BeforeAll {
    $FunctionName='Get-PasswordstateEnvironment'
    $AttributeType='System.Management.Automation.ParameterAttribute'
    $TestUri = 'https://passwordstate.local'
    $ProfilePath= 'TestDrive:\'
    $ApiKey='somekey'
    $UserName='someusername'
    $Password='SuperSecure'
    $Credential = [pscredential]::new( $UserName, (ConvertTo-SecureString -AsPlainText -String $Password -Force))
    if (Test-Path "$([environment]::GetFolderPath('UserProfile'))\passwordstate.json") {
        Rename-Item "$([environment]::GetFolderPath('UserProfile'))\passwordstate.json" "$([environment]::GetFolderPath('UserProfile'))\stowaway_passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
    }
    Import-Module -Name "$($PSScriptRoot)\..\..\passwordstate-management.psd1" -Force
}
Describe "Get-PasswordstateEnvironment" {
    Context "Validate Parameter <ParameterName>" -Foreach @(
        @{ParameterName='Path';Mandatory='False'}
    ) {
        It "should have a parameter <ParameterName>" {
            $ParameterName | Should -BeIn (Get-Command -Name $FunctionName).Parameters.Keys
        }
        It "should have Mandatory value set to <Mandatory> for parameter <ParameterName>" {
            $TestParameter = (Get-Command -Name $FunctionName).Parameters[$ParameterName]
            (($TestParameter.Attributes | Where-Object { $_.gettype().Fullname -eq $AttributeType}).Mandatory) | Should -BeExactly $Mandatory
        }
    }
    Context "Error unit testing" {
        It "Should throw when no config file can be found" {
            Remove-Item -Path "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue -Force
            { Invoke-Expression -Command "$($FunctionName) -Path '$($ProfilePath)'"} | Should -Throw
        }
    }
    Context "APIKey Unit Testing" {
        BeforeEach {
            Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $TestUri -Apikey $Apikey
        }
        AfterEach {
            Remove-Item -Path 'TestDrive:\Passwordstate.json' -Confirm:$false -Force -ErrorAction SilentlyContinue
        }
        It 'Should return a PasswordState Environment' {
            Get-PasswordStateEnvironment -path 'TestDrive:' | Should -Not -BeNullOrEmpty
        }
        It 'Should return a PasswordState Environment with Authentication ApiKey' {
            (Get-PasswordStateEnvironment -path 'TestDrive:').AuthType | Should -BeExactly 'APIKey'
        }
    }
    Context "Windows Credential Unit Testing" {
        BeforeEach {
            Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $TestUri -WindowsAuthOnly
        }
        AfterEach {
            Remove-Item -Path 'TestDrive:\Passwordstate.json' -Confirm:$false -Force -ErrorAction SilentlyContinue
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
            Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $TestUri -customcredentials $Credential
        }
        AfterEach {
            Remove-Item -Path 'TestDrive:\Passwordstate.json' -Confirm:$false -Force -ErrorAction SilentlyContinue
        }
        It 'Should return a PasswordState Environment' {
            Get-PasswordStateEnvironment -path 'TestDrive:' | Should -Not -BeNullOrEmpty
        }
        It 'Should return a PasswordState Environment with Authentication WindowsCustom' {
            (Get-PasswordStateEnvironment -path 'TestDrive:').AuthType | Should -BeExactly 'WindowsCustom'
        }
    }
}
AfterAll {
    Remove-Module -Name 'passwordstate-management' -ErrorAction SilentlyContinue
    if (Test-Path "$([environment]::GetFolderPath('UserProfile'))\stowaway_passwordstate.json") {
        Rename-Item "$([environment]::GetFolderPath('UserProfile'))\stowaway_passwordstate.json" "$([environment]::GetFolderPath('UserProfile'))\passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
    }
}