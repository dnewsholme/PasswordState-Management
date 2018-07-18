$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "New-PasswordStatePassword" {
    It "Creates a new passwords state entry for testuser" {
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

        Mock -CommandName Find-PasswordStatePassword -MockWith {
            return $null
        } -ParameterFilter {$title -eq "testuser" -and $username -eq "test"}

        Mock -CommandName Get-PasswordStateEnvironment -MockWith {return [PSCustomObject]@{
                "Baseuri" = "https://passwordstateserver.co.uk"
                "APIKey"  = "WindowsAuth"

            }
        }
        Mock -CommandName New-PasswordStateResource -MockWith {return [PSCustomObject]@{
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

        (New-PasswordStatePassword -title "testuser" -username "test" -passwordlistID "7" -Password "Password.1").Password | Should -BeExactly "Password.1"
    }
}
