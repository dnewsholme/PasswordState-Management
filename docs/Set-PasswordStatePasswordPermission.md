---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Set-PasswordStatePasswordPermission.md
schema: 2.0.0
---

# Set-PasswordStatePasswordPermission

## SYNOPSIS
Change permissions of PasswordState passwords.

## SYNTAX

### All (Default)
```
Set-PasswordStatePasswordPermission [-PasswordID] <Int32> [-Permission] <String>
 [[-ApplyPermissionsForUserID] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### PermissionID
```
Set-PasswordStatePasswordPermission [-PasswordID] <Int32> [-Permission] <String>
 [[-ApplyPermissionsForUserID] <String>] [-ApplyPermissionsForSecurityGroupID] <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### PermissionName
```
Set-PasswordStatePasswordPermission [-PasswordID] <Int32> [-Permission] <String>
 [[-ApplyPermissionsForUserID] <String>] [-ApplyPermissionsForSecurityGroupName] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Change permissions of PasswordState passwords.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-PasswordStatePasswordPermission -PasswordID 1 -Permission A -ApplyPermissionsForUserID "domain\username"
```

Change existing permissions to admin for the username on password with ID 1.

### Example 2
```powershell
PS C:\> New-PasswordStatePasswordPermission -PasswordID 1 -Permission M -ApplyPermissionsForSecurityGroupName "ReadOnlyGroup"
```

Change existing permissions to modify for the group "ReadOnlyGroup" on password with ID 1.

## PARAMETERS

### -ApplyPermissionsForSecurityGroupID
The SecurityGroupID you wish to apply permissions for.  
You can only specify SecurityGroupID or SecurityGroupName, not both in the same call.

```yaml
Type: Int32
Parameter Sets: PermissionID
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApplyPermissionsForSecurityGroupName
The SecurityGroupID you wish to apply permissions for.  
You can only specify SecurityGroupID or SecurityGroupName, not both in the same call.

```yaml
Type: String
Parameter Sets: PermissionName
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApplyPermissionsForUserID
The UserID (name) you wish to apply permissions for. Format: 'domain\username'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordID
Unique identifier for the Password.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Permission
Set permission for the password.  
M for Modify or V for View permissions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: M, V

Required: True
Position: 1
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

### System.Int32

### System.String

### System.Nullable`1[[System.Int32, System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
