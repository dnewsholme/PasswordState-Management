$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Get-PasswordStatePasswords" {
    It "Gets all Passwords from a list"{
        (Get-PasswordStatePasswords -PasswordListID 1) | Should -Not -BeNullOrEmpty
    }
    It "Checks Password is returned as type [System.Security.SecureString]" {
        (Get-PasswordStatePasswords -PasswordListID 1)[0].Password.Password | Should -BeOfType [System.Security.SecureString]
    }
    It "Checks Password is decrypted by method .GetPassword()" {
        (Get-PasswordStatePasswords -PasswordListID 1)[0].GetPassword() | Should -BeOfType [String]
    }
    It "Checks Password is decrypted by method .DecryptPassword()" {
        $result = (Get-PasswordStatePasswords -PasswordListID 1)[0]
        $result.DecryptPassword()
        $result.Password | Should -BeOfType [String]
    }
    It "Checks `$global:PasswordStateShowPasswordsPlainText is honoured" {
        $global:PasswordStateShowPasswordsPlainText = $true
        (Get-PasswordStatePasswords -PasswordListID 1)[0].Password | Should -BeOfType [String]
    }
    BeforeEach {
        # Create Test Environment
        try {
            $globalsetting = Get-Variable PasswordStateShowPasswordsPlainText -ErrorAction stop -Verbose -ValueOnly
            $global:PasswordStateShowPasswordsPlainText = $false
        }
        Catch {
            New-Variable -Name PasswordStateShowPasswordsPlainText -Value $false -Scope Global
        }
        Move-Item "$($env:USERPROFILE)\passwordstate.json" "$($env:USERPROFILE)\passwordstate.json.bak" -force
        Set-PasswordStateEnvironment -Apikey "$env:pwsapikey" -Baseuri  "$env:pwsuri"
    }
    
    AfterEach {
        # Remove Test Environment
        Move-Item  "$($env:USERPROFILE)\passwordstate.json.bak" "$($env:USERPROFILE)\passwordstate.json" -force
        $global:PasswordStateShowPasswordsPlainText = $globalsetting 
        #
    }
}
