$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "New-RandomPassword" {
    It "Returns A Random Complex Password" {
        Mock -CommandName Get-PasswordStateResource -MockWith {return [PSCustomObject]@{
                "Password" = "92839jidhiuwmdowkled-"
            }
        } -ParameterFilter {$uri -eq "/api/generatepassword"}
        (New-RandomPassword).Password | Should -BeOfType String
    }
}
