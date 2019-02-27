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

### SearchByID
```
Get-PasswordStateList [[-PasswordListID] <Int32>] [<CommonParameters>]
```

### SearchBy
```
Get-PasswordStateList [[-Searchby] <String>] [[-SearchName] <String>] [<CommonParameters>]
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
Gets the passwordlist based on ID, when omitted, gets all the passord lists

```yaml
Type: Int32
Parameter Sets: SearchByID
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Searchby
Indication when you want to search based on ID or Name

```yaml
Type: String
Parameter Sets: SearchBy
Aliases:

Required: False
Position: 1
Default value: ID
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SearchName
The name to search

```yaml
Type: String
Parameter Sets: SearchBy
Aliases:

Required: False
Position: 2
Default value: None
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
Daryl Newsholme 2018

## RELATED LINKS
