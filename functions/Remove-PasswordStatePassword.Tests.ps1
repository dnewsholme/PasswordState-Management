$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Remove-PasswordStatePassword" {
    $passwordlistID = Get-PasswordStateList -PasswordList test
    It "Removes a Password From Password State" {
        $ID = New-PasswordStatePassword -Title New -passwordlistID $passwordlistID.PasswordListID -password "Pa`$`$word"
        (Remove-PasswordStatePassword -PasswordID $ID.PasswordID ) | Should -BeNullOrEmpty
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
