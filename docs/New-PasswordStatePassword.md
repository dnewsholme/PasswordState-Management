---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# New-PasswordStatePassword

## SYNOPSIS
Creates a New Password State entry in the password list specified.

## SYNTAX

### password
```
New-PasswordStatePassword [-passwordlistID <Int32>] [-username <String>] [-description <String>]
 [-password <String>] [-title <String>] [-notes <String>] [-url <String>] [-genericfields <Hashtable>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### GeneratePassword
```
New-PasswordStatePassword [-passwordlistID <Int32>] [-username <String>] [-description <String>]
 [-GeneratePassword] [-title <String>] [-notes <String>] [-url <String>] [-genericfields <Hashtable>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a New Password State entry in the password list specified.

## EXAMPLES

### EXAMPLE 1
```
New-PasswordStatePassword -Title "testpassword" -PasswordListID 1 -username "newuser" -Password "CorrectHorseStapleBattery" -notes "development website" -url "http://somegoodwebsite.com" -customfields @{GenericField1 = 'value for GenericField1';GenericField2 = 'value2'}
```

Creates a new password entry called testpassword

## PARAMETERS

### -passwordlistID
The ID of the password list which to place the entry in.
Int32 value.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -username
The username to be added to the entry (Optional)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -description
custom description to be added to the password..

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -password
The password to be added to the entry.

```yaml
Type: String
Parameter Sets: password
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GeneratePassword
A switch parameter to generate the password based off the PasswordList Policy.

```yaml
Type: SwitchParameter
Parameter Sets: GeneratePassword
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -title
Name of the entry to be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -notes
Any notes to be added.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -url
URL to be added to the entry if relevant.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -genericfields
Hashtable with a key/value pair, that accepts GenercFields1-10 as the key, with any value.
Can be omitted

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### passwordlistID - The ID of the password list to create the password in. (Integer)
### username - Username for the entry (String)
### password - Password value for the entry (String)
### title - Title for the entry (String)
### notes - Notes for the entry (String)(Optional)
### url - URL for the entry (String)(Optional)
### description - description for entyr (Optional)
## OUTPUTS

### The entry is returned from the Password State Server.
## NOTES
Daryl Newsholme 2018
Willem R 2019

## RELATED LINKS
