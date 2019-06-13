(import-module "$psscriptroot\..\passwordstate-management.psm1" -force)
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Describe "Get-PasswordStatePassword" {
    It "Finds a Password by generic search" {
        (Get-PasswordStatePassword "test").Title | Should -BeExactly "test"
    }
    It "Finds a Password by ID" {
        (Get-PasswordStatePassword -PasswordID "1").PasswordID | Should -BeExactly 1
    }
    It "Finds a Password with a reason" {
        (Get-PasswordStatePassword -PasswordID "1" -Reason "Unit Test").PasswordID | Should -BeExactly 1
    }
    It "Finds a Password by Username Search" {
        (Get-PasswordStatePassword -UserName "test").Username | Should -BeExactly "test"
    }
    It "Checks Password is returned as type [System.Security.SecureString]" {
        (Get-PasswordStatePassword -PasswordID "1").Password.Password | Should -BeOfType [System.Security.SecureString]
    }
    It "Checks Password is decrypted by method .GetPassword()" {
        (Get-PasswordStatePassword -PasswordID "1").GetPassword() | Should -BeOfType [String]
    }
    It "Checks Password is decrypted by method .DecryptPassword()" {
        $result = (Get-PasswordStatePassword -PasswordID "1")
        $result.DecryptPassword()
        $result.Password | Should -BeOfType [String]
    }
    It "Checks `$global:PasswordStateShowPasswordsPlainText is honoured" {
        $global:PasswordStateShowPasswordsPlainText = $true
        (Get-PasswordStatePassword -PasswordID "1").Password | Should -BeOfType [String]
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

