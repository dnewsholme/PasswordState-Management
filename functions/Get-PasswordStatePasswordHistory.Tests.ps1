$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Get-PasswordStatePasswordHistory" {
    $password = (Get-passwordstatePassword) | select -first 1
    It "Gets Password History"{
        (Get-PasswordStatePasswordHistory -PasswordID $Password.PasswordID).DateChanged | Should -Not -BeNullOrEmpty
    }
    It "Checks Password is returned as type [System.Security.SecureString]" {
        (Get-PasswordStatePasswordHistory  -PasswordID $Password.PasswordID).Password.Password | Should -BeOfType [System.Security.SecureString]
    }
    It "Checks Password is decrypted by method .GetPassword()" {
        (Get-PasswordStatePasswordHistory  -PasswordID $Password.PasswordID).GetPassword() | Should -BeOfType [String]
    }
    It "Checks Password is decrypted by method .DecryptPassword()" {
        $result = (Get-PasswordStatePasswordHistory -PasswordID $Password.PasswordID)
        $result.DecryptPassword()
        $result.Password | Should -BeOfType [String]
    }
    It "Checks `$global:PasswordStateShowPasswordsPlainText is honoured" {
        $global:PasswordStateShowPasswordsPlainText = $true
        (Get-PasswordStatePasswordHistory -PasswordID $Password.PasswordID).Password | Should -BeOfType [String]
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
