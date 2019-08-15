(import-module "$psscriptroot\..\passwordstate-management.psm1" -force)
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Describe "Get-PasswordStatePassword" {
    $password = (Get-passwordstatePassword) | select -first 1
    It "Finds a Password by generic search" {
        (Get-PasswordStatePassword $Password.Title).Title | Should -BeExactly $Password.Title
    }
    It "Finds a Password by ID" {
        (Get-PasswordStatePassword -PasswordID $Password.PasswordID).PasswordID | Should -not -BeNullOrEmpty
    }
    It "Finds a Password with a reason" {
        (Get-PasswordStatePassword -PasswordID $Password.PasswordID -Reason "Unit Test").PasswordID | Should -not -BeNullOrEmpty
    }
    It "Finds a Password by Username Search" {
        (Get-PasswordStatePassword -UserName $Password.Username).Username | Should -not -BeNullOrEmpty
    }
    It "Checks Password is returned as type [System.Security.SecureString]" {
        (Get-PasswordStatePassword -PasswordID $Password.PasswordID).Password.Password | Should -BeOfType [System.Security.SecureString]
    }
    It "Checks Password is decrypted by method .GetPassword()" {
        (Get-PasswordStatePassword -PasswordID $Password.PasswordID).GetPassword() | Should -BeOfType [String]
    }
    It "Checks Password is decrypted by method .DecryptPassword()" {
        $result = (Get-PasswordStatePassword -PasswordID $Password.PasswordID)
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
        try{
            Move-Item "$($env:USERPROFILE)\passwordstate.json" "$($env:USERPROFILE)\passwordstate.json.bak" -force -ErrorAction stop
        }
        Catch{
            
        }
        Set-PasswordStateEnvironment -Apikey "$env:pwsapikey" -Baseuri  "$env:pwsuri"
    }
    
    AfterEach {
        # Remove Test Environment
        try{
            Move-Item "$($env:USERPROFILE)\passwordstate.json.bak" "$($env:USERPROFILE)\passwordstate.json" -force -ErrorAction stop
        }
        Catch{
            
        }
        $global:PasswordStateShowPasswordsPlainText = $globalsetting 
        #
    }
}

