---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# ConvertTo-PSCredential

## SYNOPSIS
Convert a password result to a PSCredential.

## SYNTAX

```
ConvertTo-PSCredential [-PasswordResult] <Object> [<CommonParameters>]
```

## DESCRIPTION
Verify the input object as a PasswordResult and convert the object to a PSCredential.

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-PSCredential -PasswordResult (Find-PasswordStatePassword '"testuser"')
```

Returns the test user object including password as a PSCredential object.

### EXAMPLE 2
```
Find-PasswordStatePassword "testuser" | ConvertTo-PSCredential
```

Returns the test user object including password as a PSCredential object.

## PARAMETERS

### -PasswordResult
A PasswordResult object returned by the Find-PasswordStatePassword function

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Returns a PSCredential object.
## NOTES
2019 - Jarno Colombeen

## RELATED LINKS
