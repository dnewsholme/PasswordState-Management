---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/New-PasswordStateDocument.md
schema: 2.0.0
---

# New-PasswordStateDocument

## SYNOPSIS
Adds a new document to an existing PasswordState Resource.

## SYNTAX

```
New-PasswordStateDocument [[-ID] <Int32>] [[-resourcetype] <String>] [[-DocumentName] <String>]
 [[-DocumentDescription] <String>] [[-Path] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds a new document to an existing PasswordState Resource.

## EXAMPLES

### EXAMPLE 1
```
New-PasswordStateDocument -ID 36 -resourcetype Password -DocumentName Testdoc.csv -DocumentDescription Important Document -Path C:\temp\1.csv
```

### EXAMPLE 2
```
Find-PasswordStatePassword test | New-PasswordStateDocument -resourcetype Password -DocumentName Testdoc.csv -DocumentDescription Important Document -Path C:\temp\1.csv
```

## PARAMETERS

### -DocumentDescription
Description to be added to the document.

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

### -DocumentName
Name of the document when it's uploaded.

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

### -ID
The ID of the resource to be updated.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: PasswordId

Required: False
Position: 0
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

### System.Int32

### System.String

## OUTPUTS

### System.Object
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
