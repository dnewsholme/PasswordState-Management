---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Remove-PasswordStatePassword.md
schema: 2.0.0
---

# Remove-PasswordStatePassword

## SYNOPSIS
Deletes a password state entry.

## SYNTAX

```
Remove-PasswordStatePassword [-PasswordID] <Int32> [-SendToRecycleBin] [[-Reason] <String>] [-PreventAuditing]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes a password state entry.

## EXAMPLES

### EXAMPLE 1
```
Remove-PasswordStatePassword -PasswordID 5 -sendtorecyclebin
```

Returns the test user object including password.

## PARAMETERS

### -PasswordID
ID value of the entry to delete.
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
Position: 3
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Reason
A reason which can be logged for auditing of why a password was removed.

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

### -SendToRecycleBin
Send the password to the recyclebin or permenant delete.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: MoveToRecycleBin

Required: False
Position: 1
Default value: False
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

### System.Management.Automation.SwitchParameter

### System.String

## OUTPUTS

### System.Object
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
