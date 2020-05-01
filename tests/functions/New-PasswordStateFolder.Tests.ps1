Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope -ModuleName 'PasswordState-Management' {
    Describe "New-PasswordStateFolder" {
    }
}
