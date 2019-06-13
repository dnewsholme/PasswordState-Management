---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Get-PasswordStateFolder

## SYNOPSIS
Finds a password state entry and returns the object.
If multiple matches it will return multiple entries.

## SYNTAX

```
Get-PasswordStateFolder [[-FolderName] <String>] [[-Description] <String>] [[-TreePath] <String>]
 [[-SiteID] <Int32>] [[-SiteLocation] <String>] [-PreventAuditing] [<CommonParameters>]
```

## DESCRIPTION
Finds a password state entry and returns the object.
If multiple matches it will return multiple entries.

## EXAMPLES

### EXAMPLE 1
```
Find-PasswordStateFolder -FolderName "test"
```

Returns the test folder object.

### EXAMPLE 2
```
Find-PasswordStateFolder -Description "testfolder"
```

Returns the folder objects that contain testfolder in the description.

## PARAMETERS

### -FolderName
The name for the folder to find

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
The description for the folder to find

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

### -TreePath
The treepath where the folder should be found

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

### -SiteID
The siteID for the folder

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteLocation
The sitelocation for the folder

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

### -PreventAuditing
{{Fill PreventAuditing Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Returns the Object from the API as a powershell object.
## NOTES
2018 - Daryl Newsholme
2019 - Jarno Colombeen

## RELATED LINKS
