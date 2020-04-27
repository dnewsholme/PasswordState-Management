---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Get-StringHash

## SYNOPSIS
Returns a hash of a string value

## SYNTAX

```
Get-StringHash [-String] <String> [-HashName] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns a hash of a string value

## EXAMPLES

### EXAMPLE 1
```
Get-StringHash -string "qwerty" -hashname SHA1
```

## PARAMETERS

### -String
String value to be converted to a hash.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -HashName
Hash type to be generated.
Valid values are "MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### b1b3773a05c0ed0176787a4f1574ff0075f7521e
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
