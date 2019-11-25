# Import functions
get-childitem $psscriptroot/Functions/*.ps1 -recurse | Where-Object {$_.fullname -notlike "*.Tests*"} | ForEach-Object {. $_.Fullname }
# Import Classes
$scriptBody = "using module $($psscriptroot)./Functions/PasswordStateClass.psm1"
$script = [ScriptBlock]::Create($scriptBody)
. $script
# Add Aliases
New-Alias -Name Find-PasswordStatePassword -Value Get-PasswordStatePassword -force