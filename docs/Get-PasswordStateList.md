---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Get-PasswordStateList.md
schema: 2.0.0
---

# Get-PasswordStateList

## SYNOPSIS
Gets all password lists from the API (Only those you have permissions to.)

## SYNTAX

### ID (Default)
```
Get-PasswordStateList [[-PasswordListID] <Int32>] [-PreventAuditing] [[-Reason] <String>] [<CommonParameters>]
```

### Specific
```
Get-PasswordStateList [[-PasswordList] <String>] [[-Description] <String>] [[-TreePath] <String>]
 [[-SiteID] <Int32>] [[-SiteLocation] <String>] [-PreventAuditing] [[-Reason] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets all password lists from the API (Only those you have permissions to.)

**Note 1**: You can perform an exact match search by enclosing your search criteria in double quotes, i.e. `'"MyList"'`

**Note 2**: By default, the retrieval of (all) PasswordList records will add one Audit record for every PasswordList record returned. If you wish to prevent audit records from being added, you can add the `-PreventAuditing` parameter.

## EXAMPLES

### EXAMPLE 1
```
Get-PasswordStateList
```

Get all available PasswordState Lists the user/api key has access to.

### EXAMPLE 2
```
Get-PasswordStateList -PasswordListID 3
```

Get the PasswordState List with ID 3.

### EXAMPLE 3
```
Get-PasswordStateList -PasswordList 'Test' -TreePath '\TestPath\Lists' -SiteID 123
```

Search for a PasswordState List with Name Test on Path \TestPath\Lists and on Site with ID 123.

### EXAMPLE 4
```
Get-PasswordStateList -PasswordList 'Test' -TreePath '\TestPath\Lists' -SiteID 123 -Reason "Ticket #202005151234567"
```

Search for a PasswordState List with Name Test on Path \TestPath\Lists and on Site with ID 123. Also specifying the reason "Ticket #202005151234567" why the search for the passwordlist object was requested.  
The Reason will be added as audit entry to every PasswordList object that will be found with these search criteria.

## PARAMETERS

### -Description
An optional parameter to filter the search on description.
The description is generally used as a longer verbose description of the nature of the Password object.

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

### -PasswordList
The name for the PasswordList to search for.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordListID
Gets the PasswordList based on ID, when omitted, gets all the password lists.

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: 0
Default value: 0
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
Position: 5
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Reason
A reason which can be logged for auditing of why a password was retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteID
An optional parameter to filter the search on the site ID.  
If you do not specify this parameter, it will report data based on all Site Locations. Values are 0 for Internal, and all other SiteID's can be found on the screen `Administration -> Remote Site Administration -> Remote Site Locations`.

```yaml
Type: Int32
Parameter Sets: Specific
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
Parameter Sets: Specific
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TreePath
The TreePath where the PasswordList can be found.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

### System.String

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES
2018 - Daryl Newsholme
2019 - Jarno Colombeen

## RELATED LINKS
