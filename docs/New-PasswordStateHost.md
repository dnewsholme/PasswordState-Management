---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# New-PasswordStateHost

## SYNOPSIS
Creates a New Password State host.

## SYNTAX

### Default (Default)
```
New-PasswordStateHost [-HostName] <String> [-HostType] <String> [-OperatingSystem] <String>
 [[-DatabaseServerType] <String>] [[-SQLInstanceName] <String>] [[-DatabasePortNumber] <Int32>]
 [-RemoteConnectionType] <String> [[-RemoteConnectionPortNumber] <Int32>]
 [[-RemoteConnectionParameters] <String>] [[-Tag] <String>] [[-Title] <String>] [[-SiteID] <Int32>]
 [[-InternalIP] <String>] [[-ExternalIP] <String>] [[-MACAddress] <String>] [-SessionRecording]
 [[-Notes] <String>] [-PreventAuditing] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### VM
```
New-PasswordStateHost [-HostName] <String> [-HostType] <String> [-OperatingSystem] <String>
 [[-DatabaseServerType] <String>] [[-SQLInstanceName] <String>] [[-DatabasePortNumber] <Int32>]
 [-RemoteConnectionType] <String> [[-RemoteConnectionPortNumber] <Int32>]
 [[-RemoteConnectionParameters] <String>] [[-Tag] <String>] [[-Title] <String>] [[-SiteID] <Int32>]
 [[-InternalIP] <String>] [[-ExternalIP] <String>] [[-MACAddress] <String>] [-SessionRecording]
 [-VirtualMachine] [-VirtualMachineType] <String> [[-Notes] <String>] [-PreventAuditing] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a New Password State host.

## EXAMPLES

### EXAMPLE 1
```
New-PasswordStateHost -HostName 'TestServer.domain.local' -HostType Windows -OperatingSystem 'Windows 10' -RemoteConnectionType RDP
```

Creates a new host with the hostname 'TestServer.domain.local'

## PARAMETERS

### -HostName
The name of the Host.
FQDN host names are preferred if possible.

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

### -HostType
A Host Type which describes the Host i.e.
Windows, Linux, Switch, Router, etc.
A list of Host Types can be found on the screen Administration -\> Passwordstate Administration -\> Host Types and Operating Systems.

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

### -OperatingSystem
The type of Operating System the Host is using.
A list of Operting Systems can be found on the screen Administration -\> Passwordstate Administration -\> Host Types and Operating Systems.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DatabaseServerType
Optional parameter that specifies the type of Database Server if applicable - MariaDB, MySQL, Oracle, PostgreSQL or SQL Server.

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

### -SQLInstanceName
Optional parameter that provides either the Microsoft SQL Server Instance Name, Oracle Service Name or PostgreSQL Database Name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DatabasePortNumber
Optional parameter that indicates the Port Number the database server is accessible on.
Leaving the Port Number blank is most cases should work, but you can specify non-standard port numbers if required

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RemoteConnectionType
The type of Remote Connection Protocol for the server i.e.
RDP, SSH, Teamviewer, Telnet or VNC.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RemoteConnectionPortNumber
The Port Number used for the Remote Connection type.
Default Port Numbers are RDP: 3389, SSH: 22, Teamviewer: 0, Telnet: 23 and VNC: 5901.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RemoteConnectionParameters
Optional parameter.
If the required Remote Session Client requires additional parameters to be specified to connect to the remote Host, they can be specified using this field.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tag
Optional descriptive Tag for the Host record.

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

### -Title
Optional title field.
If this has a value, it will be displayed in the Hosts Navigation Tree instead.

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

### -SiteID
Optional parameter.
The SiteID the Host record belongs to (SiteID of 0 for site of type Internal).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InternalIP
Optional parameter to specify the Internal IP Address of the Host.

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

### -ExternalIP
Optional parameter.
The Externally facing IP Address of the Host i.e.
if an Azure, Amazon, or an internally hosted server which has been exposed external to your standard network.

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

### -MACAddress
Optional parameter to define the network MAC Address for the Host.

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

### -SessionRecording
Optional switch.
Indicates whether all sessions will be recorded for this host record.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VirtualMachine
Optional switch that specifies if this is a Virtual Machine or not.

```yaml
Type: SwitchParameter
Parameter Sets: VM
Aliases:

Required: False
Position: 17
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VirtualMachineType
Optional parameter that, if this is a Virtual Machine, defines if it is of type Amazon, Azure, HyperV, Virtualbox, VMware or Xen.

```yaml
Type: String
Parameter Sets: VM
Aliases:

Required: True
Position: 18
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Notes
Optional parameter with any additional Notes for the Host.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
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
Position: 20
Default value: False
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

## OUTPUTS

### The created host is returned as an object.
## NOTES
2019 - Jarno Colombeen

## RELATED LINKS
