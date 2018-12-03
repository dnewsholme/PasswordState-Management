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

```
Get-PasswordStateList [[-PasswordListID] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets all password lists from the API (Only those you have permissions to.)

## EXAMPLES

### EXAMPLE 1
```
Get-PasswordStateList
```

## PARAMETERS

### -PasswordListID
{{Fill PasswordListID Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Returns the lists including their names and IDs.
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
