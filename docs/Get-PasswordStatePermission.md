---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Get-PasswordStatePermission.md
schema: 2.0.0
---

# Get-PasswordStatePermission

## SYNOPSIS
Get the permission for a password state object.

## SYNTAX

### All (Default)
```
Get-PasswordStatePermission [[-ReportID] <Int32>] [[-SiteID] <Int32>] [-ShowReportIDs] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Specific
```
Get-PasswordStatePermission [[-ReportID] <Int32>] [[-UserID] <String>] [[-SecurityGroupName] <String>]
 [[-DurationInMonth] <Int32>] [[-SiteID] <Int32>] [-ShowReportIDs] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Get the permission for a password state object.  
This script uses the functionality of `Invoke-PasswordStateReport` since the api has no native method to query the permissions of passwordstate objects.  
The report with ID **23** will by default be executed to get the permissions for all users and security groups. You can also change the permission report id with `-ReportID`.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-PasswordStatePermission -ShowReportIDs
```

Show all reports that can possibly be executed through the api in list view.

### Example 2
```powershell
PS C:\> Get-PasswordStatePermission -ReportID 23
```

Run report with ID 23 (What permissions exist (all users and security groups)?). The response (PSCustomObjects) can be filtered and used for other cmdlets/functions.

### Example 3
```powershell
PS C:\> Get-PasswordStatePermission -ReportID 24 -UserID "domain\username"
```

Run report with ID 24 (What permissions exist for a user?) and specify a user id for filtering.

## PARAMETERS

### -DurationInMonth
The period in which data can be reported against. Possible values are `0 for current month`, `1 for the past 30 days`, and then `any other integer representing the quantity of months`.

For the '**What passwords are expiring soon?**' report however, Duration refers to the **number of days** you wish to look ahead for passwords which are going to expire.

```yaml
Type: Int32
Parameter Sets: Specific
Aliases: Duration

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReportID
The ID of the Report, as documented above in the screenshot or by applying the parameter  `-ShowReportIDs`.  
Possible values: '23', '24', '25', '26', '27', '28', '37', '38', '43', '44'.  

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
The name of the Security Groups which can been seen on the screen `Administration -> Passwordstate Administration -> Security Groups`.

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

### -ShowReportIDs
Show all reports (ID + Name) for auditing permissions that can possibly be executed through the api.

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
If you leave this parameter **blank**, it will report data based on **all** Site Locations. Values are **0** for **Internal**, and all other SiteID's can be found on the screen `Administration -> Remote Site Administration -> Remote Site Locations`.  
SiteID 0 = Default site 'Internal'

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UserID
The value of **UserID** which can been seen on the screen `Administration -> Passwordstate Administration -> User Accounts`.

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

### System.String

### System.Nullable`1[[System.Int32, System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]]

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
