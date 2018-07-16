$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Find-PasswordStatePassword" {
    It "Finds a Password From Password State" {
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
                "Password"       = "testpassword"
            }
        } -ParameterFilter {$uri -eq "/api/passwords/3"}

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
                "Password"       = ""
            }
        } -ParameterFilter {$uri -eq "/api/searchpasswords/?search=testuser&ExcludePassword=true"}

        Mock -CommandName Get-PasswordStateEnvironment -MockWith {return [PSCustomObject]@{
                "Baseuri" = "https://passwordstateserver.co.uk"
                "APIKey"  = "WindowsAuth"
            
            }
        }

        (Find-PasswordStatePassword -Title "testuser").PasswordId | Should -BeExactly 3
        (Find-PasswordStatePassword -Title "testuser").Password | Should -not -BeNullOrEmpty 
    }
}
