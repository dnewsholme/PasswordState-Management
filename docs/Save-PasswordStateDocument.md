---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Save-PasswordStateDocument

## SYNOPSIS
Adds a new document to an existing PasswordState Resource.

## SYNTAX

```
Save-PasswordStateDocument [[-resourcetype] <String>] [[-DocumentID] <Int32>] [[-Path] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Adds a new document to an existing PasswordState Resource.

## EXAMPLES

### EXAMPLE 1
```
Save-PasswordStateDocument -DocumentID 36 -resourcetype Password -Path C:\temp\1.csv
```

### EXAMPLE 2
```
Find-PasswordStatePassword test | Save-PasswordStateDocument -Path C:\temp\1.csv
```

## PARAMETERS

### -resourcetype
The resource type to add the document to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Password
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DocumentID
{{Fill DocumentID Description}}

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

### -Path
File path to the document to be uploaded.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Daryl Newsholme 2018

## RELATED LINKS
