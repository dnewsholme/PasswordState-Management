# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
Install-Module PSDepend -Force

#Push-Location $psscriptroot
#Invoke-PSDepend -Force -Path $psscriptroot
#Pop-Location
Invoke-psake $PSScriptRoot\2.psake.ps1

exit ( [int]( -not $psake.build_success ) )