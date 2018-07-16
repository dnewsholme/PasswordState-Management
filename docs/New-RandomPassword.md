---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# New-RandomPassword

## SYNOPSIS
Generates a random Password from the Password state generator API

## SYNTAX

```
New-RandomPassword [[-passwordGeneratorID] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Generates a random Password from the Password state generator API

## EXAMPLES

### EXAMPLE 1
```
New-RandomPassword
```

## PARAMETERS

### -passwordGeneratorID
The ID to of the password generator settings (optional)

```yaml
Type: Object
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

### PasswordGeneratorID - Optional parameter if you want to generate a more or less secure password.

## OUTPUTS

### A string value of the generated password.

## NOTES
Daryl Newsholme 2019

## RELATED LINKS
