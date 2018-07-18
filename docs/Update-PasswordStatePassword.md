---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Update-PasswordStatePassword

## SYNOPSIS
Updates the password of an existing password state entry.

## SYNTAX

```
Update-PasswordStatePassword [-passwordID] <Object> [-password] <String> [<CommonParameters>]
```

## DESCRIPTION
Updates the password of an existing password state entry.

## EXAMPLES

### EXAMPLE 1
```
Update-PasswordStatePassword -PasswordlistID 5 -PasswordID 1 -Password "76y288uneeko%%%2A" -title "testuser01"
```

Updates the password to "76y288uneeko%%%2A" for the entry named testuser01

## PARAMETERS

### -passwordID
The ID of the password to be updated.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -password
The new password to be added to the entry.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### All fields must be specified, can be passed along the pipeline.

## OUTPUTS

### Will output all fields for the entry from passwordstate including the new password.

## NOTES
Daryl Newsholme 2018

## RELATED LINKS
