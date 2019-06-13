$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "New-PasswordStatePassword" {
    It "Creates a new password state entry Password Entry" {
        $result = New-PasswordStatePassword -title "bob" -username "test" -passwordlistID "1" -Password "Password.1"
        ($result).GetPassword() | Should -BeExactly "Password.1"
    }
    It "Creates a new passworsdstate entry with generated Password" {
        $result = New-PasswordStatePassword -title "bob" -username "test" -passwordlistID "1" -GeneratePassword
        ($result).GetPassword() | Should -Not -BeNullOrEmpty
    }
    It "Checks a new password state entry Password Entry returns an encrypted string" {
        $result = New-PasswordStatePassword -title "bob" -username "test" -passwordlistID "1" -Password "Password.1"
        ($result).Password.Password | Should -BeOfType [System.Security.SecureString]
    }
    It "Checks `$global:PasswordStateShowPasswordsPlainText is honoured" {
        $global:PasswordStateShowPasswordsPlainText = $true
        $result = New-PasswordStatePassword -title "bob" -username "test" -passwordlistID "1" -Password "Password.1"
        ($result).Password | Should -BeExactly "Password.1"
    }
    It "Fails to create a password when one already matches" {
        $result = New-PasswordStatePassword -title "bob" -username "test" -passwordlistID "1" -Password "Password.1"
        {New-PasswordStatePassword -title "bob" -username "test" -passwordlistID "1" -Password "Password.1"} | Should -Throw
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
        try {
            Get-PasswordStatePassword bob -ErrorAction stop |Remove-PasswordStatePassword -ErrorAction stop
        }
        Catch{

        }
    }
    
    AfterEach {
        # Remove Test Environment
        Move-Item  "$($env:USERPROFILE)\passwordstate.json.bak" "$($env:USERPROFILE)\passwordstate.json" -force
        $global:PasswordStateShowPasswordsPlainText = $globalsetting
        try {
            Get-PasswordStatePassword bob -ErrorAction stop | Remove-PasswordStatePassword -ErrorAction stop
        }
        Catch{

        }
        #
    }
}
