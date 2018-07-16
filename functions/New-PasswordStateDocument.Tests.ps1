$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Get-PasswordStateList" {
    It "Returns All Password State Password Lists" {
        Mock -CommandName New-PasswordStateResource -MockWith {return [PSCustomObject]@{
                "DocumentID"   = 4
                "DocumentName" = "Test"
            }
        } -ParameterFilter {$uri -eq "/api/document/password/3?DocumentName=Test&DocumentDescription=Test"}
        "Test" | Out-File "TestDrive:\1.txt"
        (New-PasswordStateDocument -ID 3 -resourcetype password -DocumentName "Test" -DocumentDescription "Test" -Path "TestDrive:\1.txt").DocumentID | Should -BeOfType Int32
    }
}
