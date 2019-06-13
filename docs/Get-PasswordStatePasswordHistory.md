---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Get-PasswordStatePasswordHistory

## SYNOPSIS
Gets a password state entry historical password entries.

## SYNTAX

```
Get-PasswordStatePasswordHistory [[-PasswordID] <Int32>] [[-reason] <String>] [-PreventAuditing]
 [<CommonParameters>]
```

## DESCRIPTION
Gets a password state entry historical password entries..

## EXAMPLES

### EXAMPLE 1
```
Get-PasswordStatePassword -PasswordID 5
```

Returns the test user object including password.

## PARAMETERS

### -PasswordID
ID value of the entry to find history for.
Int32 value

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

### -reason
A reason which can be logged for auditing of why a password was retrieved.

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

### -PreventAuditing
{{Fill PreventAuditing Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### PasswordID - ID of the Password entry (Integer)
## OUTPUTS

### Returns the Object from the API as a powershell object.
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
