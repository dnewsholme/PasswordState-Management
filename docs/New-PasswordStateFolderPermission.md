---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/New-PasswordStateFolderPermission.md
schema: 2.0.0
---

# New-PasswordStateFolderPermission

## SYNOPSIS
Add permissions to a PasswordState folder.

## SYNTAX

### All (Default)
```
New-PasswordStateFolderPermission [-FolderID] <Int32> [-Permission] <String>
 [[-ApplyPermissionsForUserID] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### PermissionID
```
New-PasswordStateFolderPermission [-FolderID] <Int32> [-Permission] <String>
 [[-ApplyPermissionsForUserID] <String>] [-ApplyPermissionsForSecurityGroupID] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### PermissionName
```
New-PasswordStateFolderPermission [-FolderID] <Int32> [-Permission] <String>
 [[-ApplyPermissionsForUserID] <String>] [-ApplyPermissionsForSecurityGroupName] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Add permissions to a PasswordState folder.

**Note**: To add permissions to a Folder, it must be configured to have its **permissions managed manually**.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-PasswordStateFolderPermission -FolderID 1 -Permission A -ApplyPermissionsForUserID "domain\username"
```

Grant administrator permissions to the username on folder with ID 1.

### Example 2
```powershell
PS C:\> New-PasswordStateFolderPermission -FolderID 1 -Permission V -ApplyPermissionsForSecurityGroupName "ReadOnlyGroup"
```

Grant view permissions to the group "ReadOnlyGroup" on folder with ID 1.

## PARAMETERS

### -ApplyPermissionsForSecurityGroupID
The SecurityGroupID you wish to apply permissions for.  
You can only specify SecurityGroupID or SecurityGroupName, not both in the same call.

```yaml
Type: String
Parameter Sets: PermissionID
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApplyPermissionsForSecurityGroupName
The Security Group Name you wish to apply permissions for.  
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

### -FolderID
Unique identifier for the Folder.

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
Set permission for the folder.  
A for Administrator, M for Modify or V for View permissions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: A, M, V

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

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
