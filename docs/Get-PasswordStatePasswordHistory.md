---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Get-PasswordStatePasswordHistory.md
schema: 2.0.0
---

# Get-PasswordStatePasswordHistory

## SYNOPSIS
Gets a password state entry historical password entries.

## SYNTAX

```
Get-PasswordStatePasswordHistory [-PasswordID] <Int32> [[-reason] <String>] [-PreventAuditing]
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

Required: True
Position: 0
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PreventAuditing
By default, the creation/modification or retrieval of (all) Passwords records will add one Audit record for every Password record returned. If you wish to prevent audit records from being added, you can add this `-PreventAuditing` parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
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
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

### System.String

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object[]

## NOTES
Daryl Newsholme 2018

## RELATED LINKS
