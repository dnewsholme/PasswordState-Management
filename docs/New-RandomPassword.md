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

### General (Default)
```
New-RandomPassword [[-length] <Int32>] [-includebrackets] [-includespecialcharacters] [-includenumbers]
 [-includelowercase] [-includeuppercase] [[-excludedcharacters] <String>] [-Quantity <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### PolicyID
```
New-RandomPassword [-PolicyID] <Int32> [-Quantity <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Generates a random Password from the Password state generator API

## EXAMPLES

### EXAMPLE 1
```
New-RandomPassword
```

### EXAMPLE 2
```
New-RandomPassword -length 60 -includenumbers -includeuppercase -includelowercase -includespecialcharacters -includebrackets -Quantity 1
```

### EXAMPLE 3
```
New-RandomPassword -PolicyID 2
```

## PARAMETERS

### -length
Length for the generated password

```yaml
Type: Int32
Parameter Sets: General
Aliases:

Required: False
Position: 1
Default value: 12
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PolicyID
ID for an existing Password Generator ID

```yaml
Type: Int32
Parameter Sets: PolicyID
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -includebrackets
If brackets should be included such as {}()

```yaml
Type: SwitchParameter
Parameter Sets: General
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -includespecialcharacters
If special characters such as ^_\> should be included.

```yaml
Type: SwitchParameter
Parameter Sets: General
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -includenumbers
If numbers should be included.

```yaml
Type: SwitchParameter
Parameter Sets: General
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -includelowercase
If lowercase characters should be included.

```yaml
Type: SwitchParameter
Parameter Sets: General
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -includeuppercase
If uppercase should be included.

```yaml
Type: SwitchParameter
Parameter Sets: General
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -excludedcharacters
{{Fill excludedcharacters Description}}

```yaml
Type: String
Parameter Sets: General
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Quantity
The quantity of passwords to generate.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
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

### PasswordGeneratorID - Optional parameter if you want to generate a more or less secure password.
## OUTPUTS

### A string value of the generated password.
## NOTES
Daryl Newsholme 2019

## RELATED LINKS
