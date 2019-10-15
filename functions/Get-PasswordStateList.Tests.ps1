$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Get-PasswordStateList" {
    $list = ((Get-PasswordStateList)) | select -First 1
    It "Returns All Password State Password Lists" {
        (Get-PasswordStateList).PasswordListID | Should -not -BeNullOrEmpty
    }
    It "Search Password State Password Lists by ID" {
        (Get-PasswordStateList -PasswordListID $list.PasswordListID).PasswordListID | should -BeExactly $list.PasswordListID
    }
    It "Search Password State Password Lists by Name" {
        (Get-PasswordStateList -PasswordList $list.PasswordList).PasswordList | Should -BeExactly $list.PasswordList
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
            Move-Item "$($env:USERPROFILE)\passwordstate.json.bak" "$($env:USERPROFILE)\passwordstate.json" -force -ErrorAction stop -ErrorAction stop
        }
        Catch{
            
        }
        $global:PasswordStateShowPasswordsPlainText = $globalsetting 
        #
    }
}
