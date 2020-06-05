---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/New-PasswordStateList.md
schema: 2.0.0
---

# New-PasswordStateList

## SYNOPSIS
Creates a passwordstate List.

## SYNTAX

### All (Default)
```
New-PasswordStateList [-Name] <String> [-Description] <String> [[-FolderID] <Int32>]
 [[-ImageFileName] <String>] [[-SiteID] <Int32>] [-AllowExport] [[-Guide] <String>] [-PreventBadPasswordUse]
 [-PasswordResetEnabled] [[-PasswordGeneratorID] <Int32>] [[-PasswordStrengthPolicyID] <Int32>] [-Sort]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Permission
```
New-PasswordStateList [-Name] <String> [-Description] <String> [[-FolderID] <Int32>]
 [[-CopySettingsFromPasswordListID] <String>] [[-CopyPermissionsFromPasswordListID] <String>]
 [[-CopySettingsFromTemplateID] <String>] [[-CopyPermissionsFromTemplateID] <String>]
 [[-LinkToTemplate] <String>] [[-ApplyPermissionsForUserID] <String>]
 [[-ApplyPermissionsForSecurityGroupID] <String>] [[-ApplyPermissionsForSecurityGroupName] <String>]
 [-Permission] <String> [[-ImageFileName] <String>] [[-SiteID] <Int32>] [-AllowExport] [[-Guide] <String>]
 [-PreventBadPasswordUse] [-PasswordResetEnabled] [[-PasswordGeneratorID] <Int32>]
 [[-PasswordStrengthPolicyID] <Int32>] [-Sort] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ListSettings
```
New-PasswordStateList [-Name] <String> [-Description] <String> [[-FolderID] <Int32>]
 [-CopySettingsFromPasswordListID] <String> [[-ImageFileName] <String>] [[-SiteID] <Int32>] [-AllowExport]
 [[-Guide] <String>] [-PreventBadPasswordUse] [-PasswordResetEnabled] [[-PasswordGeneratorID] <Int32>]
 [[-PasswordStrengthPolicyID] <Int32>] [-Sort] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Private
```
New-PasswordStateList [-Name] <String> [-Description] <String> [[-FolderID] <Int32>]
 [[-CopySettingsFromPasswordListID] <String>] [-PrivatePasswordList] [[-ApplyPermissionsForUserID] <String>]
 [[-Permission] <String>] [[-ImageFileName] <String>] [[-SiteID] <Int32>] [-AllowExport] [[-Guide] <String>]
 [-PreventBadPasswordUse] [-PasswordResetEnabled] [[-PasswordGeneratorID] <Int32>]
 [[-PasswordStrengthPolicyID] <Int32>] [-Sort] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### TemplateSettings
```
New-PasswordStateList [-Name] <String> [-Description] <String> [[-FolderID] <Int32>]
 [-CopySettingsFromTemplateID] <String> [[-ImageFileName] <String>] [[-SiteID] <Int32>] [-AllowExport]
 [[-Guide] <String>] [-PreventBadPasswordUse] [-PasswordResetEnabled] [[-PasswordGeneratorID] <Int32>]
 [[-PasswordStrengthPolicyID] <Int32>] [-Sort] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Template
```
New-PasswordStateList [-Name] <String> [-Description] <String> [[-FolderID] <Int32>]
 [[-CopySettingsFromTemplateID] <String>] [-LinkToTemplate] <String> [-PrivatePasswordList]
 [[-ImageFileName] <String>] [[-SiteID] <Int32>] [-AllowExport] [[-Guide] <String>] [-PreventBadPasswordUse]
 [-PasswordResetEnabled] [[-PasswordGeneratorID] <Int32>] [[-PasswordStrengthPolicyID] <Int32>] [-Sort]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a passwordstate List.  
Adding a new Password List object can be achieved by making a POST request on the URL, with appropriate fields forming the HTTP message body. To create Password Lists, you must have access to the 'Add Shared Password List' and/or 'Add Private Password List' menus within the Passwordstate UI.  

When creating a new Password List, there are a few options for copying settings and permissions from other Password Lists or Templates, where to place the Password List in the Navigation Tree, and if you want to link the Password List to a Template.  

The following example shows, in PowerShell, how to create a a new Password List, nest the new Password List beneath the new Folder and setting permissions/settings for this newly created list.  

## EXAMPLES

### EXAMPLE 1
```
New-PasswordStateList -Name TestList -Description "A Test List" -FolderID 4
```

Creates a basic shared password list with the name, description provided under the folder with ID 4.

### EXAMPLE 2
```
New-PasswordStateList -Name "TestSharedList" -description "Test shared password list" -FolderID 4 -ApplyPermissionsForSecurityGroupName "PasswordState_Security_Admins" -Permission "A" -Guide "Test123" -CopySettingsFromTemplateID 1
```

Creates an advanced shared password list under folder with ID 4. Applying administrator permissions to an existing security group. The settings will be copied from an existing password list template with ID 1 and also a guide will be added.

### EXAMPLE 3
```
New-PasswordStateList -Name "TestPrivateList" -PrivatePasswordList -description "Test private password list" -FolderID 4 -ApplyPermissionsForUserID "domain\username" -Permission A
```

Creates a private password list under folder with ID 4. Applying administrator permissions to the given user.

## PARAMETERS

### -AllowExport
Not implemented yet to the PasswordState (Win)API.  

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApplyPermissionsForSecurityGroupID
Specified which Security Group, by ID, which will be given permission to this newly created Password List. You cannot apply permissions for a Security Group by ID and Name during the same API call.  

```yaml
Type: String
Parameter Sets: Permission
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApplyPermissionsForSecurityGroupName
Specified which Security Group, by Name, which will be given permission to this newly created Password List. You cannot apply permissions for a Security Group by ID and Name during the same API call.  

```yaml
Type: String
Parameter Sets: Permission
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApplyPermissionsForUserID
Specified which User, by Name, will be given permission to this newly created Password List.

```yaml
Type: String
Parameter Sets: Permission, Private
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CopyPermissionsFromPasswordListID
Optionally copy the permissions from another list.  
To copy permissions to the Password List from an existing Password List, you can specify the PasswordListID value for this field.  

```yaml
Type: String
Parameter Sets: Permission
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CopyPermissionsFromTemplateID
Optionally copy the permissions from a password list template.  
To copy permissions to the Password List from an existing Password List Template, you can specify the TemplateID value for this field.  

```yaml
Type: String
Parameter Sets: Permission
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CopySettingsFromPasswordListID
Optionally copy the settings from another list.  
To copy settings and field configurations to the Password List from an existing Password List, you have to specify the PasswordListID value for this field.

```yaml
Type: String
Parameter Sets: Permission, Private
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ListSettings
Aliases:

Required: True
Position: 3
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CopySettingsFromTemplateID
Optionally copy the settings from password list template.  
To copy settings and field configurations to the Password List from an existing Password Template, you can specify the TemplateID value for this field.  

```yaml
Type: String
Parameter Sets: Permission, Template
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: TemplateSettings
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
Description for the list.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FolderID
Folder ID that the list should be placed under.  
If you would like this newly created Password List to be nested beneath another Folder or Password List, specify the FolderID or PasswordList value here.  
If omitted, the Password List will be created in the root of the Navigation Tree - which is equivalent to the value of 0. i.e. FolderID 0 = Folder will be created in the root of the Navigation Tree.  

**Note**: If you are nested this Password List beneath a Folder structure which is propagating its permissions down, then you cannot use any of the CopyPermissionsFrom properties.  

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: NestUnderFolderID

Required: False
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Guide
Any associated instructions (guide) for how the password list should be used.  
Can contain HTML characters BUT HTML will, for security reasons, not be rendered anymore in PasswordState.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ImageFileName
An image file name associated with the Password List - as can be seen on the screen Administration -> PasswordState Administration -> Images and Account Types.  

```yaml
Type: String
Parameter Sets: (All)
Aliases: Image

Required: False
Position: 13
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LinkToTemplate
Link template to an existing password list template.  
If you want to Link the new Password List to an existing Password List Template, then you can specify the TemplateID here.  

**Note**: When doing this, you must also specify a value for the field CopySettingsFromTemplateID, and not use the field CopySettingsFromPasswordListID.  

```yaml
Type: String
Parameter Sets: Permission
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Template
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the Passwordstate list.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordGeneratorID
Not implemented yet to the PasswordState (Win)API.  

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordResetEnabled
Not implemented yet to the PasswordState (Win)API.  

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordStrengthPolicyID
Not implemented yet to the PasswordState (Win)API.  
PasswordStrengthPolicyID 1 = 'Default Password Strength Policy'.  

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Permission
When apply permissions to the newly created Password List (for a User or Security Group), you must specify the values of A, M or V - Administrator, Modify or View rights.  

```yaml
Type: String
Parameter Sets: Permission
Aliases:
Accepted values: A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V

Required: True
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Private
Aliases:
Accepted values: A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V, A, M, V

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PreventBadPasswordUse
Not implemented yet to the PasswordState (Win)API.  

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PrivatePasswordList
To create either a Shared or Private Password List - specify True or False.  

**Note**: When creating a Private Password List for a user, you cannot copy permissions from other Password List or Template, or apply permissions based on a Security Group.  

```yaml
Type: SwitchParameter
Parameter Sets: Private
Aliases:

Required: True
Position: 4
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: Template
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteID
By default, the Site Location of 'Internal' will be used if an alternate Site Location is not used.  
SiteID 0 = Default site 'Internal'  

**Note**: SiteID's can be referenced on the screen Administration -> Remote Site Administration -> Remote Site Locations. For the site of "Internal", the SiteID = 0.  

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Sort
Sort the response (returned object) by name.  

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: False
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
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Int32

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
