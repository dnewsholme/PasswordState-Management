---
external help file: PasswordState-Management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Get-PasswordStateFolder

## SYNOPSIS
Finds a password state entry and returns the object.
If multiple matches it will return multiple entries.

## SYNTAX

```
Get-PasswordStateFolder [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Finds a password state entry and returns the object.
If multiple matches it will return multiple entries.

## EXAMPLES

### EXAMPLE 1
```
Find-PasswordStateFolder -Name "test"
```

Returns the test folder object.

## PARAMETERS

### -Name
A string value which should match the passwordstate entry exactly(Not case sensitive)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Name - The title of the entry (string)

## OUTPUTS

### Returns the Object from the API as a powershell object.

## NOTES
Daryl Newsholme 2018

## RELATED LINKS
