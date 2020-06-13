# List of forbidden commands
$global:BannedCommands = @(
	'Write-Host',
	'Write-Verbose',
	'Write-Warning',
	'Write-Error',
	'Write-Output',
	'Write-Information',
	'Write-Debug',
	
	# Use CIM instead where possible
	'Get-WmiObject',
	'Invoke-WmiMethod',
	'Register-WmiEvent',
	'Remove-WmiObject',
	'Set-WmiInstance'
)

<#
	Contains list of exceptions for banned cmdlets.
	Insert the file names of files that may contain them.
	
	Example:
	"Write-Host"  = @('Write-PSFHostColor.ps1','Write-PSFMessage.ps1')
#>
$global:MayContainCommand = @{
	"Write-Host"        = @()
	"Write-Verbose"     = @('2.psake.ps1', 'New-PasswordStateList.ps1', 'New-RandomPassword.ps1', 'Remove-PasswordStateResource.ps1', 'Set-PasswordStateResource.ps1', 'Get-PasswordStateResource.ps1')
	"Write-Warning"     = @('2.psake.ps1')
	"Write-Error"       = @('2.psake.ps1', 'New-PasswordStateResource.ps1')
	"Write-Output"      = @('4.Analyze.ps1')
	"Write-Information" = @()
	"Write-Debug"       = @()
}