---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Get-PasswordStatePasswords

## SYNOPSIS
Gets All PasswordStatePasswords from a list, based on ID.
Use Get-PasswordStateList to search for a name and return the ID

## SYNTAX

```
Get-PasswordStatePasswords [[-PasswordlistID] <Int32[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets All PasswordStatePasswords from a list, based on ID.
Use Get-PasswordStateList to search for a name and return the ID

## EXAMPLES

### EXAMPLE 1
```
Get-PasswordStatePassword -PasswordListID 1
```

Returns all user objects including password.

## PARAMETERS

### -PasswordlistID
An ID of a specific passwordlist resource to return.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Willem R 2019

## RELATED LINKS
