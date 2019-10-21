$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "New-PasswordStateFolder" {
    It "Creates a folder in Password State" {
        Mock -CommandName New-PasswordStateResource -MockWith {return [PSCustomObject]@{
                "FolderID"    = "4"
                "FolderName"  = "Test"
                "TreePath"    = "\Root\Test"
                "Description" = ""
            }
        } -ParameterFilter {$uri -eq "/Folders" -and $body -ne $null}

        Mock -CommandName Get-PasswordStateEnvironment -MockWith {return [PSCustomObject]@{
                "Baseuri" = "https://passwordstateserver.co.uk"
                "APIKey"  = "WindowsAuth"

            }
        }
    }
    (New-PasswordStateFolder -Name "Test" -description "test").FolderID | Should -BeExactly 4

}
