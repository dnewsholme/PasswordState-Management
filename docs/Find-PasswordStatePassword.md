---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Find-PasswordStatePassword

## SYNOPSIS
Finds a password state entry and returns the object.
If multiple matches it will return multiple entries.

## SYNTAX

### 1 (Default)
```
Find-PasswordStatePassword [[-title] <String[]>] [[-username] <String[]>] [<CommonParameters>]
```

### 2
```
Find-PasswordStatePassword [[-PasswordID] <Int32[]>] [<CommonParameters>]
```

## DESCRIPTION
Finds a password state entry and returns the object.
If multiple matches it will return multiple entries.

## EXAMPLES

### EXAMPLE 1
```
Find-PasswordStatePassword -title "testuser"
```

Returns the test user object including password.

## PARAMETERS

### -title
A string value which should match the passwordstate entry exactly(Not case sensitive)

```yaml
Type: String[]
Parameter Sets: 1
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -username
An optional parameter to filter searches to those with a certain username as multiple titles may have the same value.

```yaml
Type: String[]
Parameter Sets: 1
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordID
An ID of a specific password resource to return.

```yaml
Type: Int32[]
Parameter Sets: 2
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Title - The title of the entry (string)
Username - The username you need the password for. If multiple entries have the same name this is useful to get the one you want only. (String)(Optional)

## OUTPUTS

### Returns the Object from the API as a powershell object.

## NOTES
Daryl Newsholme 2018

## RELATED LINKS
