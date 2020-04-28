---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/eizedev/PasswordState-Management/blob/master/docs/Remove-PasswordStateResource.md
schema: 2.0.0
---

# Remove-PasswordStateResource

## SYNOPSIS
A function to simplify the deletion of password state resources via the rest API

## SYNTAX

```
Remove-PasswordStateResource [[-uri] <String>] [[-method] <String>] [[-ContentType] <String>]
 [[-extraparams] <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
A function to simplify the deletion of password state resources via the rest API.

## EXAMPLES

### EXAMPLE 1
```
Remove-PasswordStateResource -uri "/api/lists?LISTID"
```

Removes a password list on the password api.

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
Optional Parameter to override the method from Delete.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: DELETE
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
Position: 3
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
Position: 4
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
