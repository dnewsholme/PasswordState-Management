---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Set-PasswordStateEnvironment

## SYNOPSIS
Saves your password state environment configuration to be used when calling the rest api.

## SYNTAX

### Two (Default)
```
Set-PasswordStateEnvironment -Baseuri <String> [-WindowsAuthOnly] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### One
```
Set-PasswordStateEnvironment -Baseuri <String> [-Apikey <String>] [-PasswordGeneratorAPIkey <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Three
```
Set-PasswordStateEnvironment -Baseuri <String> [-customcredentials <PSCredential>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Saves your password state environment configuration to be used when calling the rest api.
This enables quickly calling the API without having to enter a key each time or the URL, the key is stored encrypted.

## EXAMPLES

### EXAMPLE 1
```
Set-PasswordStateEnvironment -baseuri "https://passwordstateserver" -UseWindowsAuthOnly
```

Sets to use windows passthrough authentication to interact with the API

### EXAMPLE 2
```
Set-PasswordStateEnvironment -baseuri "https://passwordstateserver" -APIKey "hdijdiwkjod9wu9dikwokd3uerunh"
```

Sets to use an API key interact with the API.
Note that password lists can only be retrieved with the System API key.

## PARAMETERS

### -Baseuri
The base url of the passwordstate server.
eg https://passwordstate

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Apikey
For use if APIKey is the preferred authentication method.

```yaml
Type: String
Parameter Sets: One
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PasswordGeneratorAPIkey
{{Fill PasswordGeneratorAPIkey Description}}

```yaml
Type: String
Parameter Sets: One
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsAuthOnly
For use if Windows Passthrough is the preferred authentication method.

```yaml
Type: SwitchParameter
Parameter Sets: Two
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -customcredentials
For use if windows custom credentials is the preferred authentication method.

```yaml
Type: PSCredential
Parameter Sets: Three
Aliases:

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

### Baseuri - Should be the Password State URL without any parameters on it.
### UseWindowsAuthOnly - A switch value. (Don't use in conjunction with APIkey)
### APIkey - The APIkey for the passwordstate API
## OUTPUTS

### No Output
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
