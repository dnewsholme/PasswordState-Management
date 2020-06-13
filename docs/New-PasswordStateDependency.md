---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/New-PasswordStateDependency.md
schema: 2.0.0
---

# New-PasswordStateDependency

## SYNOPSIS
Adding a New Password Reset Dependency to an existing PasswordState Password resource.

## SYNTAX

### General (Default)
```
New-PasswordStateDependency [-PasswordID] <Int32> [-ScriptID] <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Dependency
```
New-PasswordStateDependency [[-DependencyType] <String>] [[-DependencyName] <String>] [-PasswordID] <Int32>
 [-ScriptID] <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Host
```
New-PasswordStateDependency [[-HostName] <String>] [-PasswordID] <Int32> [-ScriptID] <Int32> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adding a New Password Reset Dependency to an existing PasswordState Password resource.
When an account is enabled to perform Password Resets, it possible to have 'dependant' tasks which can also be executed at the same time the password is reset. Examples of this are where Active Directory accounts are being used for Windows Services, Scheduled Tasks and IIS Application Pools. You can also add a dependant reset task which does not relate to these types of Windows resources i.e. you can execute any custom PowerShell script you want.

If you wish to execute a script Post Reset, you do not need to specify a dependency (DependencyName, DependencyType), or Host (HostName) record to link it to - you can execute any custom script you like.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-PasswordStateDependency -DependencyType 'Windows Service' -DependencyName 'Test Dependency' -PasswordID 2 -ScriptID 8
```

Adding a Password Reset Dependency that will reset the a windows service password using the script 'Reset Windows Service Password' (ScriptID: 8) for password with ID 8.

### Example 2
```powershell
PS C:\> New-PasswordStateDependency -PasswordID 2 -ScriptID 43
```

Adding a Password Reset Post Reset script (ScriptID 43) to password resource with ID 2 that will be executed once the Password record has finished executing its own password reset task.

## PARAMETERS

### -DependencyName
The actual name of the Dependency, as it relates to Windows resources i.e. the name of a Windows Service, or Scheduled Task.

```yaml
Type: String
Parameter Sets: Dependency
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DependencyType
DependencyType relates to Windows type resources. Possible values are Windows Service, IIS Application Pool, Scheduled Tasks and COM+ Component.


```yaml
Type: String
Parameter Sets: Dependency
Aliases:
Accepted values: Windows Service, IIS Application Pool, Scheduled Tasks, COM+ Component

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -HostName
If this dependant task is to be executed against a specific Host, then you specify the name of the Host here - it must match the name of the Host as it is recorded in PasswordState. If this dependant task is not to be executed against a specific Host, then this parameter can be omitted.

```yaml
Type: String
Parameter Sets: Host
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordID
The PasswordID value of the password record in PasswordState.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ScriptID
The ScriptID value of the dependant script which will be executed, once the Password record has finished executing its own password reset task.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
