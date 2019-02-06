$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Get-PasswordStateFolder" {
    It "Finds a Folder From Password State" {
        Mock -CommandName Get-PasswordStateResource -MockWith {return [PSCustomObject]@{
                "FolderID"    = "4"
                "FolderName"  = "Test"
                "TreePath"    = "\Root\Test"
                "Description" = ""
            }
        } -ParameterFilter {$uri -eq "/api/folders/?FolderName=Test"}
        (Get-PasswordStateFolder -Name "Test").FolderID | Should -BeExactly 4
    }
    

    It "Generates a web exception" {
        Mock -CommandName Get-PasswordStateResource -MockWith {throw [System.Net.WebException]"Resource Not Found"
        } -ParameterFilter {$uri -eq "/api/folders/?FolderName=Test"}
        {Get-PasswordStateFolder -Name "Test"} | Should -Throw
    }
   
}
