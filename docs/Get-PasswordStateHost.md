---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# Get-PasswordStateHost

## SYNOPSIS
Finds a password state host and returns the object.
If multiple matches it will return multiple entries.

## SYNTAX

```
Get-PasswordStateHost [[-HostName] <String>] [[-HostType] <String>] [[-OperatingSystem] <String>]
 [[-DatabaseServerType] <String>] [[-SiteID] <Int32>] [[-SiteLocation] <String>] [-PreventAuditing]
 [<CommonParameters>]
```

## DESCRIPTION
Finds a password state host and returns the object.
If multiple matches it will return multiple entries.

## EXAMPLES

### EXAMPLE 1
```
Get-PasswordStateHost
```

Returns all hosts you have access to.

### EXAMPLE 2
```
Get-PasswordStateHost 'testhost'
```

Returns the test host object.

### EXAMPLE 3
```
Get-PasswordStateHost -OperatingSystem 'Windows Server 2012'
```

Returns the hosts that are using the Windows Server 2012 operating system.

### EXAMPLE 4
```
Get-PasswordStateHost -DatabaseServerType 'SQL Server,Oracle'
```

Returns the hosts that are of the database server type SQL Servers and Oracle

## PARAMETERS

### -HostName
An optional parameter to filter the search on hostname.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -HostType
An optional parameter to filter the search on type of host.

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

### -OperatingSystem
An optional parameter to filter the search on operating system.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DatabaseServerType
An optional parameter to filter the search on database server type.

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

### -SiteID
An optional parameter to filter the search on the site ID.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteLocation
An optional parameter to filter the search on the site location.

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

### -PreventAuditing
An optional parameter to prevent logging this API call in the audit log (Can be overruled in PasswordState preferences).

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Returns the Object from the API as a powershell object.
## NOTES
2019 - Jarno Colombeen

## RELATED LINKS
