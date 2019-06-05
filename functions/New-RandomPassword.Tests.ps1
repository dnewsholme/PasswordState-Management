$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "New-RandomPassword" {
    It "Generates a default Password" {
        (New-RandomPassword) | Should -not -BeNullOrEmpty
    }

    It "Generates a default Password of length 20" {
        (New-RandomPassword -length 20).Password.length | Should -BeExactly 20
    }
    It "Generates a Password from a policy" {
        (New-RandomPassword -PolicyID 1).Password | Should -not -BeNullOrEmpty
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
        Set-PasswordStateEnvironment -Apikey "$env:pwsapikey" -Baseuri  "$env:pwsuri" -PasswordGeneratorAPIkey "$env:pwsgenapikey"
    }
    
    AfterEach {
        # Remove Test Environment
        Move-Item  "$($env:USERPROFILE)\passwordstate.json.bak" "$($env:USERPROFILE)\passwordstate.json" -force
        $global:PasswordStateShowPasswordsPlainText = $globalsetting
    }
}
