$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Update-PasswordStatePassword" {
    $password = (Get-passwordstatePassword) | select -first 1
    it "Updates an existing password" {
        (Update-PasswordStatePassword -passwordID $Password.PasswordID -Password "Password.1").GetPassword() | Should -BeExactly "Password.1"
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
    }

}
