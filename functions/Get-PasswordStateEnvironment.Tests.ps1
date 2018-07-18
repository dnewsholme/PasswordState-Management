$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-PasswordStateEnvironment" {
    It "Loads the Password State JSON" {
        $location = $env:USERPROFILE
        $env:USERPROFILE = "TestDrive:\"
        Set-PasswordStateEnvironment -Baseuri "https://passswordstate" -WindowsAuthOnly
        Get-PasswordStateEnvironment | Should -Not -BeNullOrEmpty
        $env:USERPROFILE = $location
    }
}
