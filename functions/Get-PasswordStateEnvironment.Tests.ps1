$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-PasswordStateEnvironment" {
    It "Loads the Password State JSON windows auth" {
        $location = $env:USERPROFILE
        $env:USERPROFILE = "TestDrive:\"
        Set-PasswordStateEnvironment -Baseuri "https://passswordstate" -WindowsAuthOnly
        Get-PasswordStateEnvironment | Should -Not -BeNullOrEmpty
        $env:USERPROFILE = $location
    }

    It "Loads the Password State JSON API key" {
        $location = $env:USERPROFILE
        $env:USERPROFILE = "TestDrive:\"
        Set-PasswordStateEnvironment -Baseuri "https://passswordstate" -Apikey "oooooooo"
        Get-PasswordStateEnvironment | Should -Not -BeNullOrEmpty
        $env:USERPROFILE = $location
    }

    It "Loads the Password State JSON custom credentials" {
        $location = $env:USERPROFILE
        $cred = New-Object System.Management.Automation.PSCredential -ArgumentList "username", ("password" | ConvertTo-SecureString -AsPlainText -Force)
        $env:USERPROFILE = "TestDrive:\"
        Set-PasswordStateEnvironment -Baseuri "https://passswordstate" -customcredentials $cred
        Get-PasswordStateEnvironment | Should -Not -BeNullOrEmpty
        $env:USERPROFILE = $location
    }

    It "Checks that no environment would throw error " {
        $location = $env:USERPROFILE
        $env:USERPROFILE = "TestDrive:\empty"
        {Get-PasswordStateEnvironment} | Should -Throw -ErrorId "No environment has been set. Run Set-PasswordStateEnvironment to create first."
        $env:USERPROFILE = $location
    }
}
