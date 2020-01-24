# Add all things you want to run before importing the main code

# Load the strings used in messages
. Import-ModuleFile -Path "$($script:ModuleRoot)\internal\scripts\strings.ps1"
. Import-ModuleFile -Path "$($Script:ModuleRoot)\internal\functions\PasswordStateClass.ps1"
Add-Type -AssemblyName System.Web
