---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Remove-PasswordStateListPermission.md
schema: 2.0.0
---

# Remove-PasswordStateListPermission

## SYNOPSIS
Remove permissions of PasswordState list.

## SYNTAX

### All (Default)
```
Remove-PasswordStateListPermission [-PasswordListID] <Int32> [[-Permission] <String>]
 [[-ApplyPermissionsForUserID] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### PermissionID
```
Remove-PasswordStateListPermission [-PasswordListID] <Int32> [[-Permission] <String>]
 [[-ApplyPermissionsForUserID] <String>] [-ApplyPermissionsForSecurityGroupID] <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### PermissionName
```
Remove-PasswordStateListPermission [-PasswordListID] <Int32> [[-Permission] <String>]
 [[-ApplyPermissionsForUserID] <String>] [-ApplyPermissionsForSecurityGroupName] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Remove permissions of PasswordState list.

**Note**: To remove permissions of a Password List, it cannot be receiving permissions from a **parent folder** which is **propagating permissions down**.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-PasswordStateListPermission -PasswordListID 1 -ApplyPermissionsForUserID "domain\username"
```

Remove permissions for the username on list with ID 1.

### Example 2
```powershell
PS C:\> Remove-PasswordStateListPermission -PasswordListID 1 -ApplyPermissionsForSecurityGroupName "ReadOnlyGroup"
```

Remove permissions for the group "ReadOnlyGroup" on list with ID 1.

### Example 2
```powershell
PS C:\> Remove-PasswordStateListPermission -PasswordListID 1 -Permission "V" -ApplyPermissionsForSecurityGroupName "ReadOnlyGroup"
```

Remove "V" (View) permissions for the group "ReadOnlyGroup" on list with ID 1. You can specify the `-Permission` parameter, but you do not need to specify it. If you specify it, it must be the correct Permission.

## PARAMETERS

### -ApplyPermissionsForSecurityGroupID
The SecurityGroupID you wish to remove permissions for.  
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
The SecurityGroupID you wish to remove permissions for.  
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
The UserID (name) you wish to remove permissions for. Format: 'domain\username'

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

### -PasswordListID
Unique identifier for the Password List.

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
Remove permission for the password list.  
A for Administrator, M for Modify or V for View permissions.

**Note**: This is optional. If omitted, all permissions for the User or Security Group will be deleted. Or you can specify specific permissions using the above defined permission levels.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: A, M, V

Required: False
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
