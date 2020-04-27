---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Set-PasswordStateResource

## SYNOPSIS
A function to simplify the modification/updates of password state resources via the rest API

## SYNTAX

```
Set-PasswordStateResource [[-uri] <String>] [[-method] <String>] [[-body] <String>] [[-ContentType] <String>]
 [[-extraparams] <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
A function to simplify the modification/updates of password state resources via the rest API.

## EXAMPLES

### EXAMPLE 1
```
Set-PasswordStateResource -uri "/api/passwords" -body "{"Password":"somevalue","PasswordID":"7"}
```

Sets a password on the password api.

## PARAMETERS

### -uri
The api resource to access such as /api/lists

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -method
Optional Parameter to override the method from PUT.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: PUT
Accept pipeline input: False
Accept wildcard characters: False
```

### -body
The body to be submitted in the rest request it should be in JSON format.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContentType
Optional Parameter to override the default content type from application/json.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Application/json
Accept pipeline input: False
Accept wildcard characters: False
```

### -extraparams
Optional Parameter to allow extra parameters to be passed to invoke-restmethod.
Should be passed as a hashtable.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Will return the response from the rest API.
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
