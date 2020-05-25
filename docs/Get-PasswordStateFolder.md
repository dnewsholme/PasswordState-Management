---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Get-PasswordStateFolder.md
schema: 2.0.0
---

# Get-PasswordStateFolder

## SYNOPSIS
Find a PasswordState folder entry and returns the object.  
If multiple matches it will return multiple objects.

## SYNTAX

```
Get-PasswordStateFolder [[-FolderName] <String>] [[-Description] <String>] [[-TreePath] <String>]
 [[-SiteID] <Int32>] [[-SiteLocation] <String>] [[-FolderID] <Int32>] [-PreventAuditing] [[-Reason] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Find a PasswordState folder entry and returns the object.  
If multiple matches it will return multiple objects.

**Note 1**: You can perform an exact match search by enclosing your search criteria in double quotes, i.e. `'"MyFolder"'`

**Note 2**: By default, the retrieval of (all) folder records will add one Audit record for every folder record returned. If you wish to prevent audit records from being added, you can add the `-PreventAuditing` parameter.

## EXAMPLES

### EXAMPLE 1
```
Get-PasswordStateFolder -FolderName "test"
```

Returns the folder object(s) with name "test".

### EXAMPLE 2
```
Get-PasswordStateFolder -Description "testfolder"
```

Returns the folder object(s) that contains testfolder in the description.

### EXAMPLE 3
```
Get-PasswordStateFolder -FolderID 12
```

Returns the folder object(s) with FolderID 12 if found.

## PARAMETERS

### -Description
An optional parameter to filter the search on description.
The description is generally used as a longer verbose description of the nature of the Password object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FolderID
The unique ID of the folder to filter the search for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FolderName
The name for the folder to search for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PreventAuditing
By default, the creation/modification or retrieval of (all) Passwords records will add one Audit record for every Password record returned. If you wish to prevent audit records from being added, you can add this `-PreventAuditing` parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Reason
A reason which can be logged for auditing of why a folder was retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteID
An optional parameter to filter the search on the site ID.  
If you do not specify this parameter, it will report data based on all Site Locations. Values are 0 for Internal, and all other SiteID's can be found on the screen `Administration -> Remote Site Administration -> Remote Site Locations`.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteLocation
An optional parameter to filter the search on the site location.  
If you do not specify this parameter, it will report data based on all Site Locations. Values are the name of the Site Location that can be found on the screen `Administration -> Remote Site Administration -> Remote Site Locations`.

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

### -TreePath
The TreePath where the folder should be found.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Nullable`1[[System.Int32, System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]]

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES
2018 - Daryl Newsholme
2019 - Jarno Colombeen

## RELATED LINKS
