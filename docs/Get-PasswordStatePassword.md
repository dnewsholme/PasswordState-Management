---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Get-PasswordStatePassword

## SYNOPSIS
Finds a password state entry and returns the object.
If multiple matches it will return multiple entries.

## SYNTAX

### General (Default)
```
Get-PasswordStatePassword [[-Search] <String>] [[-PasswordListID] <Int32>] [[-Reason] <String>]
 [-PreventAuditing] [<CommonParameters>]
```

### PasswordID
```
Get-PasswordStatePassword [-PasswordID] <Int32> [[-Reason] <String>] [-PreventAuditing] [<CommonParameters>]
```

### Specific
```
Get-PasswordStatePassword [[-Title] <String>] [[-UserName] <String>] [[-HostName] <String>]
 [[-Domain] <String>] [[-AccountType] <String>] [[-Description] <String>] [[-Notes] <String>] [[-URL] <String>]
 [[-SiteID] <String>] [[-SiteLocation] <String>] [[-GenericField1] <String>] [[-GenericField2] <String>]
 [[-GenericField3] <String>] [[-GenericField4] <String>] [[-GenericField5] <String>]
 [[-GenericField6] <String>] [[-GenericField7] <String>] [[-GenericField8] <String>]
 [[-GenericField9] <String>] [[-GenericField10] <String>] [[-PasswordListID] <Int32>] [[-Reason] <String>]
 [-PreventAuditing] [<CommonParameters>]
```

## DESCRIPTION
Finds a password state entry and returns the object.
If multiple matches it will return multiple entries.

## EXAMPLES

### EXAMPLE 1
```
Get-PasswordStatePassword "testuser"
```

Returns the test user object including password.

### EXAMPLE 2
```
Get-PasswordStatePassword -Title '"testuser"'
```

Returns the object including password, which is an exact match with the title (Requires double quotes for exact match).

### EXAMPLE 3
```
Get-PasswordStatePassword -Username "testuser2" -Notes "Test"
```

Returns the test user 2 object, where the notes contain "Test", including password.

### EXAMPLE 4
```
Get-PasswordStatePassword -PasswordID "3456"
```

Returns the object with the PasswordID 3456 including password.

## PARAMETERS

### -Search
A string value which will be matched with most fields in the database table.

```yaml
Type: String
Parameter Sets: General
Aliases:

Required: False
Position: 1
Default value: %
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -PasswordID
An ID of a specific password resource to return.

```yaml
Type: Int32
Parameter Sets: PasswordID
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Title
A string value which should match the passwordstate entry.

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

### -UserName
An optional parameter to filter searches to those with a certain username as multiple titles may have the same value.

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

### -HostName
An optional parameter to filter the search on hostname.

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

### -Domain
An optional parameter to filter the search on domain.

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

### -AccountType
An optional parameter to filter the search on account type.

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

### -Description
An optional parameter to filter the search on description.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Notes
An optional parameter to filter the search on notes.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -URL
An optional parameter to filter the search on the URL.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteID
An optional parameter to filter the search on the site ID.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteLocation
An optional parameter to filter the search on the site location.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField1
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField2
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField3
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField4
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField5
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField6
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField7
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField8
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField9
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField10
An optional parameter to filter the search on a generic field.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordListID
An optional parameter to filter the search on a specific password list.

```yaml
Type: Int32
Parameter Sets: General, Specific
Aliases:

Required: False
Position: 2
Default value: 0
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
Position: 22
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
Position: 23
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
