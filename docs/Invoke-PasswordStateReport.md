---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Invoke-PasswordStateReport

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### All (Default)
```
Invoke-PasswordStateReport [[-ReportID] <Int32>] [[-SiteID] <Nullable`1[]>] [-ShowReportIDs]
 [-ShowAllReportIDs] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Specific
```
Invoke-PasswordStateReport [[-ReportID] <Int32>] [[-UserID] <String>] [[-SecurityGroupName] <String>]
 [[-DurationInMonth] <Nullable`1[]>] [[-SiteID] <Nullable`1[]>] [[-PasswordListIDs] <Nullable`1[]>]
 [-QueryExpiredPasswords] [-ShowReportIDs] [-ShowAllReportIDs] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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

### -DurationInMonth
Possible values are 0 for current month, 1 for the past 30 days, and then any other integer representing the quantity of months.

```yaml
Type: Nullable`1[]
Parameter Sets: Specific
Aliases: Duration

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordListIDs
{{ Fill PasswordListIDs Description }}

```yaml
Type: Nullable`1[]
Parameter Sets: Specific
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -QueryExpiredPasswords
{{ Fill QueryExpiredPasswords Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Specific
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReportID
Possible values: 1-49

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SecurityGroupName
{{ Fill SecurityGroupName Description }}

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ShowAllReportIDs
{{ Fill ShowAllReportIDs Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ShowReportIDs
{{ Fill ShowReportIDs Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteID
SiteID 0 = Default site 'Internal'

```yaml
Type: Nullable`1[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UserID
{{ Fill UserID Description }}

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 0
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

### System.String

### System.Nullable`1[[System.Int32, System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]][]

### System.Nullable`1[[System.Int32, System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]]

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
