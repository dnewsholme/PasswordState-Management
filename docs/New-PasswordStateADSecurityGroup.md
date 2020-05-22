---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/New-PasswordStateADSecurityGroup.md
schema: 2.0.0
---

# New-PasswordStateADSecurityGroup

## SYNOPSIS
Creates an Active Directory Security Group in PasswordState.

## SYNTAX

```
New-PasswordStateADSecurityGroup [-SecurityGroupName] <String> [[-Description] <String>]
 [-ADDomainNetBIOS] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates/Imports an Active Directory Security Group in PasswordState.

To add a Security Group, the user account executing the script must be given access to the **Security Groups Security Administrator role**.

**Note**: Once you have added the Security Group via the API, the Passwordstate Windows Service will start synchronizing its members within **one minute** of the Security Group being added.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ADDomainNetBIOS
The NetBIOS Name for the appropriate domain from the screen `Administration -> Active Directory Domains`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
A description for the Security Group. The description of the Active Directory Security Group will not be imported (missing API feature), you need to specify the description.

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

### -SecurityGroupName
The name of the Security Group in Active Directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 0
Default value: None
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

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
