$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Update-PasswordStatePassword" {
    It "Finds a Password From Password State and passes it to be changed to Password.1" {
        Mock -CommandName Get-PasswordStateResource -MockWith {return [PSCustomObject]@{
                "Title"          = "testuser"
                "Username"       = "test"
                "Domain"         = ""
                "Description"    = ""
                "PasswordId"     = 3
                "AccountType"    = ""
                "URL"            = ""
                "Passwordlist"   = "MockedList"
                "PasswordListID" = 7
            }
        } -ParameterFilter {$uri -eq "/api/passwords/7?QueryAll&ExcludePassword=true"}

        Mock -CommandName Find-PasswordStatePassword -MockWith {return [PSCustomObject]@{
                "Title"          = "testuser"
                "Username"       = "test"
                "Password"       = "Password"
                "Domain"         = ""
                "Description"    = ""
                "PasswordId"     = 3
                "AccountType"    = ""
                "URL"            = ""
                "Passwordlist"   = "MockedList"
                "PasswordListID" = 7
            }
        } -ParameterFilter {$passwordID -eq 3}

        Mock -CommandName Get-PasswordStateEnvironment -MockWith {return [PSCustomObject]@{
                "Baseuri" = "https://passwordstateserver.co.uk"
                "APIKey"  = "WindowsAuth"

            }
        }
        Mock -CommandName Set-PasswordStateResource -MockWith {return [PSCustomObject]@{
                "Title"          = "testuser"
                "Password"       = "Password.1"
                "Username"       = "test"
                "Domain"         = ""
                "Description"    = ""
                "PasswordId"     = 3
                "AccountType"    = ""
                "URL"            = ""
                "Passwordlist"   = "MockedList"
                "PasswordListID" = 7
            }
        } -ParameterFilter {$uri -eq "/api/passwords" -and $body -notlike $null}

        (Update-PasswordStatePassword -passwordID 3 -Password "Password.1").Password | Should -BeExactly "Password.1"
    }
}
