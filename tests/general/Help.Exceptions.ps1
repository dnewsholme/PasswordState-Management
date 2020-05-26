# List of functions that should be ignored
$global:FunctionHelpTestExceptions = @(
  'Get-NativePath'
  , 'Get-PasswordStateEnvironment'
  , 'Get-PasswordStateHost'
  , 'Get-PasswordStateFolder'
  , 'Get-PasswordStateList'
  , 'Get-PasswordStatePassword'
  , 'Get-PasswordStatePasswordHistory'
  , 'Get-StringHash'
  , 'New-PasswordStateDocument'
  , 'New-PasswordStateFolder'
  , 'New-PasswordStateHost'
  , 'New-PasswordStateList'
  , 'New-PasswordStatePassword'
  , 'New-RandomPassword'
  , 'Remove-PasswordStateHost'
  , 'Remove-PasswordStatePassword'
  , 'Remove-PasswordStatePlainTextPasswordFlag'
  , 'Save-PasswordStateDocument'
  , 'Set-PasswordStateEnvironment'
  , 'Set-PasswordStatePlainTextPasswordFlag'
  , 'Set-PasswordStateResource'
  , 'Test-PasswordPwned'
  , 'New-PasswordStateResource'
  , 'Remove-PasswordStateResource'
  , 'Get-PasswordStatePermission'
  , 'New-PasswordStateListPermission'
  , 'New-PasswordStatePasswordPermission'
  , 'Remove-PasswordStateListPermission'
  , 'Remove-PasswordStatePasswordPermission'
  , 'Set-PasswordStateListPermission'
  , 'Set-PasswordStatePassword'
  , 'Set-PasswordStatePasswordPermission'
  , 'New-PasswordStateSelfDestructMessage'
)

<#
  List of arrayed enumerations. These need to be treated differently. Add full name.
  Example:

  "Sqlcollaborative.Dbatools.Connection.ManagementConnectionType[]"
#>
$global:HelpTestEnumeratedArrays = @(
	
)

<#
  Some types on parameters just fail their validation no matter what.
  For those it becomes possible to skip them, by adding them to this hashtable.
  Add by following this convention: <command name> = @(<list of parameter names>)
  Example:

  "Get-DbaCmObject"       = @("DoNotUse")
#>
$global:HelpTestSkipParameterType = @{
    
}
