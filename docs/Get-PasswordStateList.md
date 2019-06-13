---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Get-PasswordStateList

## SYNOPSIS
Gets all password lists from the API (Only those you have permissions to.)

## SYNTAX

### ID (Default)
```
Get-PasswordStateList [[-PasswordListID] <Int32>] [-PreventAuditing] [<CommonParameters>]
```

### Specific
```
Get-PasswordStateList [[-PasswordList] <String>] [[-Description] <String>] [[-TreePath] <String>]
 [[-SiteID] <Int32>] [[-SiteLocation] <String>] [-PreventAuditing] [<CommonParameters>]
```

## DESCRIPTION
Gets all password lists from the API (Only those you have permissions to.)

## EXAMPLES

### EXAMPLE 1
```
Get-PasswordStateList
```

### EXAMPLE 2
```
Get-PasswordStateList -PasswordListID 3
```

### EXAMPLE 3
```
Get-PasswordStateList -PasswordList 'Test' -TreePath '\TestPath\Lists' -SiteID 123
```

## PARAMETERS

### -PasswordListID
Gets the passwordlist based on ID, when omitted, gets all the passord lists

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordList
The name for the PasswordList to find

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
The description for the PasswordList to find

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TreePath
The treepath where the PasswordList should be found

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteID
The siteID for the PasswordList

```yaml
Type: Int32
Parameter Sets: Specific
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteLocation
The sitelocation for the PasswordList

```yaml
Type: String
Parameter Sets: Specific
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

### Returns the lists including their names and IDs.
## NOTES
2018 - Daryl Newsholme
2019 - Jarno Colombeen

## RELATED LINKS
