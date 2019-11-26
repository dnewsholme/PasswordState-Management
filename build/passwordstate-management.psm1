# Import functions
get-childitem $psscriptroot/Functions/*.ps1 -recurse | Where-Object {$_.fullname -notlike "*.Tests*"} | ForEach-Object {. $_.Fullname }
# Import Classes
# Add Aliases
New-Alias -Name Find-PasswordStatePassword -Value Get-PasswordStatePassword -force
# Add required assemblies.
Add-Type -AssemblyName System.Web