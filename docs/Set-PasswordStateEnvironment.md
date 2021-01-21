---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Set-PasswordStateEnvironment.md
schema: 2.0.0
---

# Set-PasswordStateEnvironment

## SYNOPSIS
Saves your password state environment configuration to be used when calling the rest api.

## SYNTAX

### Two (Default)
```
Set-PasswordStateEnvironment -Uri <Uri> [-WindowsAuthOnly] [-path <String>] [-SetPlainTextPasswords <Boolean>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### One
```
Set-PasswordStateEnvironment -Uri <Uri> [-Apikey <String>] [-PasswordGeneratorAPIkey <String>] [-path <String>]
 [-SetPlainTextPasswords <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Three
```
Set-PasswordStateEnvironment -Uri <Uri> [-customcredentials <PSCredential>] [-path <String>]
 [-SetPlainTextPasswords <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Saves your password state environment configuration to be used when calling the rest api.
This enables quickly calling the API without having to enter a key each time or the URL, the key is stored encrypted.

## EXAMPLES

### EXAMPLE 1
```
Set-PasswordStateEnvironment -Uri "https://passwordstateserver" -UseWindowsAuthOnly
```

Sets to use windows passthrough authentication to interact with the API

### EXAMPLE 2
```
Set-PasswordStateEnvironment -Uri "https://passwordstateserver" -APIKey "hdijdiwkjod9wu9dikwokd3uerunh"
```

Sets to use an API key interact with the API.
Note that password lists can only be retrieved with the System API key.

## PARAMETERS

### -Apikey
For use if APIKey is the preferred authentication method.

```yaml
Type: String
Parameter Sets: One
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordGeneratorAPIkey
The API Key for the password generator usage.

```yaml
Type: String
Parameter Sets: One
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -path
The path to the json configuration file for the passwordstate environment.

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

### -SetPlainTextPasswords
Set to true, if plaintext passwords shall be displayed.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
The url of the passwordstate website.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: Baseuri

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Accept pipeline input: True (ByPropertyName)
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

### System.Uri

### System.String

### System.Management.Automation.SwitchParameter

### System.Management.Automation.PSCredential

## OUTPUTS

### System.Object
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
