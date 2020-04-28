---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/eizedev/PasswordState-Management/blob/master/docs/Import-ModuleFile.md
schema: 2.0.0
---

# Import-ModuleFile

## SYNOPSIS
Loads files into the module on module import.

## SYNTAX

```
Import-ModuleFile [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
This helper function is used during module initialization.
It should always be dotsourced itself, in order to proper function.

This provides a central location to react to files being imported, if later desired

## EXAMPLES

### EXAMPLE 1
```
. Import-ModuleFile -File $function.FullName
```

Imports the file stored in $function according to import policy

## PARAMETERS

### -Path
The path to the file to load

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
