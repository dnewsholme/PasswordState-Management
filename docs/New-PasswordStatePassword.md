---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/New-PasswordStatePassword.md
schema: 2.0.0
---

# New-PasswordStatePassword

## SYNOPSIS
Creates a New Password State entry in the password list specified.

## SYNTAX

### password
```
New-PasswordStatePassword [-passwordlistID] <Int32> [-title] <String> [[-username] <String>]
 [[-password] <String>] [[-description] <String>] [[-notes] <String>] [[-url] <String>]
 [[-GenericField1] <String>] [[-GenericField2] <String>] [[-GenericField3] <String>]
 [[-GenericField4] <String>] [[-GenericField5] <String>] [[-GenericField6] <String>]
 [[-GenericField7] <String>] [[-GenericField8] <String>] [[-GenericField9] <String>]
 [[-GenericField10] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### GeneratePassword
```
New-PasswordStatePassword [-passwordlistID] <Int32> [-title] <String> [[-username] <String>]
 [[-description] <String>] [-GeneratePassword] [[-notes] <String>] [[-url] <String>]
 [[-GenericField1] <String>] [[-GenericField2] <String>] [[-GenericField3] <String>]
 [[-GenericField4] <String>] [[-GenericField5] <String>] [[-GenericField6] <String>]
 [[-GenericField7] <String>] [[-GenericField8] <String>] [[-GenericField9] <String>]
 [[-GenericField10] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
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

### -GeneratePassword
A switch parameter to generate the password based off the PasswordList Policy.

```yaml
Type: SwitchParameter
Parameter Sets: GeneratePassword
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField1
{{Fill GenericField1 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField10
{{Fill GenericField10 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField2
{{Fill GenericField2 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField3
{{Fill GenericField3 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField4
{{Fill GenericField4 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField5
{{Fill GenericField5 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField6
{{Fill GenericField6 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField7
{{Fill GenericField7 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField8
{{Fill GenericField8 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField9
{{Fill GenericField9 Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
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

### -description
custom description to be added to the password..

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 6
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
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -passwordlistID
The ID of the password list which to place the entry in.
Int32 value.

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

### -title
Name of the entry to be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 7
Default value: None
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
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
