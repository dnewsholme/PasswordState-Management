$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"

Describe "Get-PasswordStateFolder" {
    It "Finds a Folder From Password State on FolderName" {
        (Get-PasswordStateFolder -FolderName "Test").FolderID | Should -not -BeNullOrEmpty
    }
    
    It "Finds a Folder From Password State on Description" {
        (Get-PasswordStateFolder -Description "Test").FolderID | Should -not -BeNullOrEmpty
    }
    
    It "Generates a web exception" {
        {Get-PasswordStateFolder -FolderName "DoesntExist"} | Should -Throw
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
        New-PasswordStateFolder -Name Test -description Test
    }
    
    AfterEach {
        # Remove Test Environment
        Move-Item  "$($env:USERPROFILE)\passwordstate.json.bak" "$($env:USERPROFILE)\passwordstate.json" -force
        $global:PasswordStateShowPasswordsPlainText = $globalsetting 
        #
    }
}
