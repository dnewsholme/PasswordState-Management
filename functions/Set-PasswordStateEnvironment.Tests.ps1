$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Set-PasswordStateEnvironment (Windows Auth)" {
    It "Sets a Password State enviromnent with Windows Auth" {
        $original = $env:USERPROFILE
        $env:USERPROFILE = "TestDrive:\"
        Set-PasswordStateEnvironment -Baseuri "https://passwordstate" -WindowsAuthOnly
        (Get-Content "$($env:USERPROFILE)\passwordstate.json" | ConvertFrom-Json).AuthType | Should -BeExactly "WindowsIntegrated"
        $env:USERPROFILE = $original
    }
}

Describe "Set-PasswordStateEnvironment (Windows Custom Credentials)" {
    It "Sets a Password State enviromnent with Windows Custom Credentials" {
        $original = $env:USERPROFILE
        $env:USERPROFILE = "TestDrive:\"
        $cred = New-Object System.Management.Automation.PSCredential -ArgumentList "username", $("password" | ConvertTo-SecureString -AsPlainText -Force)
        Set-PasswordStateEnvironment -Baseuri "https://passwordstate" -customcredentials $cred
        (Get-Content "$($env:USERPROFILE)\passwordstate.json" | ConvertFrom-Json).AuthType | Should -BeExactly "WindowsCustom"
        $env:USERPROFILE = $original
    }
}

Describe "Set-PasswordStateEnvironment (APIKey)" {
    It "Sets a Password State enviromnent with APIKey" {
        $original = $env:USERPROFILE
        $env:USERPROFILE = "TestDrive:\"
        Set-PasswordStateEnvironment -Baseuri "https://passwordstate" -Apikey "9d0si0dkwoijd-we-2ed-ewfd-ew--3-"
        (Get-Content "$($env:USERPROFILE)\passwordstate.json" | ConvertFrom-Json).AuthType | Should -BeExactly "APIKey"
        $env:USERPROFILE = $original
    }
}