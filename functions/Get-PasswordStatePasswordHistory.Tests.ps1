$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Get-PasswordStatePasswordHistory" {
    It "Password history should be at least 1" {
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
                "DateChanged"    = "07/06/2018 09:22:12"
            }
        } -ParameterFilter {$uri -eq "/api/passwordhistory/3"}

        (Get-PasswordStatePasswordHistory -PasswordID 3).DateChanged | Should -Not -BeNullOrEmpty  
    }
}
