---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Save-PasswordStateDocument.md
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

### -DocumentID
The ID of the document that will be uploaded.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -resourcetype
The resource type to add the document to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: password, passwordlist, folder

Required: False
Position: 1
Default value: Password
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Int32

## OUTPUTS

### System.Object
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
