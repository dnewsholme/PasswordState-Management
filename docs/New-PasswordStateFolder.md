---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/New-PasswordStateFolder.md
schema: 2.0.0
---

# New-PasswordStateFolder

## SYNOPSIS
Creates a passwordstate Folder.

## SYNTAX

```
New-PasswordStateFolder [-Name] <String> [-Description] <String>
 [[-CopyPermissionsFromPasswordListID] <String>] [[-CopyPermissionsFromTemplateID] <String>]
 [[-FolderID] <Int32>] [[-Guide] <String>] [[-SiteID] <Int32>] [-PropagatePermissions] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a passwordstate Folder.

## EXAMPLES

### EXAMPLE 1
```
New-PasswordStateFolder -Name TestFolder -Description "A Test Folder" -FolderID 4
```

Creates the folder "TestFolder" under the folder with ID 4.

### EXAMPLE 2
```
New-PasswordStateFolder -Name TestFolder -Description "A Test Folder" -FolderID 4 -CopyPermissionsFromPasswordListID 1
```

Creates the folder "TestFolder" under the folder with ID 4 and copies the permissions from the existing password list with ID 1.

### EXAMPLE 3
```
New-PasswordStateFolder -Name TestFolder -Description "A Test Folder" -FolderID 4 -Guide "This is a Test Guide"
```

Creates the folder "TestFolder" under the folder with ID 4 and adding a guide.

### EXAMPLE 4
```
New-PasswordStateFolder -Name TestFolder -Description "A Test Folder" -FolderID 4 -SiteID 1
```

Creates the folder "TestFolder" under the folder with ID 4 using the Site Location with ID 1 (Not the default Internal Site)

## PARAMETERS

### -CopyPermissionsFromPasswordListID
To copy permissions to the Folder from an existing Password List, you can specify the PasswordListID value for this field.  

**Note 1**: By default, Folders inherit permissions from any nested Password Lists beneath them. So if you intend to create a Password List nested beneath this folder, you may not need to copy any permissions here.  
**Note 2**: If you are nested this Folder beneath another Folder which is propagating its permissions down, then you cannot copy permissions from an existing Password List.  

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CopyPermissionsFromTemplateID
To copy permissions to the Folder from an existing Password List Template, you can specify the TemplateID value for this field.  

**Note 1**: By default, Folders inherit permissions from any nested Password Lists beneath them. So if you intend to create a Password List nested beneath this folder, you may not need to copy any permissions here.  
**Note 2**: If you are nested this Folder beneath another Folder which is propagating its permissions down, then you cannot copy permissions from an existing Password List Template.  

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
Description fro the Folder

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
If you would like this newly created Folder to be nested beneath another Folder or Password List, specify the FolderID or PasswordListID value here. If omitted, the Folder will be created in the root of the Navigation Tree - which is equivalent to the value of 0.  
Will default to root (ID 0) if left blank.

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
Any associated instructions (guide) for how the Folder should be used.  
Can contain HTML characters BUT HTML will, for security reasons, not be rendered anymore in PasswordState.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the Passwordstate Folder.

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

### -PropagatePermissions
If you want the folder to propagate its permissions down to all nested Password Lists and Folders, then you set PropagatePermissions to true.  

**Note 1**: If using this option, you still need to copy permissions from an existing Password List or Template.  

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteID
By default, the Site Location of 'Internal' will be used if an alternate Site Location is not used.  
Will default to site 'Internal' (ID 0) if left blank.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
