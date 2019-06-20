<#
    .SYNOPSIS
    Creates a New Password State host.
    .DESCRIPTION
    Creates a New Password State host.

    .EXAMPLE
    PS C:\> New-PasswordStateHost -HostName 'TestServer.domain.local' -HostType Windows -OperatingSystem 'Windows 10' -RemoteConnectionType RDP
    Creates a new host with the hostname 'TestServer.domain.local'

    .PARAMETER HostName
    The name of the Host. FQDN host names are preferred if possible.
    .PARAMETER HostType
    A Host Type which describes the Host i.e. Windows, Linux, Switch, Router, etc. A list of Host Types can be found on the screen Administration -> Passwordstate Administration -> Host Types and Operating Systems.
    .PARAMETER OperatingSystem
    The type of Operating System the Host is using. A list of Operting Systems can be found on the screen Administration -> Passwordstate Administration -> Host Types and Operating Systems.
    .PARAMETER DatabaseServerType
    Optional parameter that specifies the type of Database Server if applicable - MariaDB, MySQL, Oracle, PostgreSQL or SQL Server.
    .PARAMETER SQLInstanceName
    Optional parameter that provides either the Microsoft SQL Server Instance Name, Oracle Service Name or PostgreSQL Database Name.
    .PARAMETER DatabasePortNumber
    Optional parameter that indicates the Port Number the database server is accessible on. Leaving the Port Number blank is most cases should work, but you can specify non-standard port numbers if required
    .PARAMETER RemoteConnectionType
    The type of Remote Connection Protocol for the server i.e. RDP, SSH, Teamviewer, Telnet or VNC.
    .PARAMETER RemoteConnectionPortNumber
    The Port Number used for the Remote Connection type. Default Port Numbers are RDP: 3389, SSH: 22, Teamviewer: 0, Telnet: 23 and VNC: 5901.
    .PARAMETER RemoteConnectionParameters
    Optional parameter. If the required Remote Session Client requires additional parameters to be specified to connect to the remote Host, they can be specified using this field.
    .PARAMETER Tag
    Optional descriptive Tag for the Host record.
    .PARAMETER Title
    Optional title field. If this has a value, it will be displayed in the Hosts Navigation Tree instead.
    .PARAMETER SiteID
    Optional parameter. The SiteID the Host record belongs to (SiteID of 0 for site of type Internal).
    .PARAMETER InternalIP
    Optional parameter to specify the Internal IP Address of the Host.
    .PARAMETER ExternalIP
    Optional parameter. The Externally facing IP Address of the Host i.e. if an Azure, Amazon, or an internally hosted server which has been exposed external to your standard network.
    .PARAMETER MACAddress
    Optional parameter to define the network MAC Address for the Host.
    .PARAMETER SessionRecording
    Optional switch. Indicates whether all sessions will be recorded for this host record.
    .PARAMETER VirtualMachine
    Optional switch that specifies if this is a Virtual Machine or not.
    .PARAMETER VirtualMachineType
    Optional parameter that, if this is a Virtual Machine, defines if it is of type Amazon, Azure, HyperV, Virtualbox, VMware or Xen.
    .PARAMETER Notes
    Optional parameter with any additional Notes for the Host.

    .PARAMETER PreventAuditing
    An optional parameter to prevent logging this API call in the audit log (Can be overruled in PasswordState preferences).

    .OUTPUTS
    The created host is returned as an object.

    .NOTES
    2019 - Jarno Colombeen
#>
Function New-PasswordStateHost
{
  [CmdletBinding(SupportsShouldProcess = $true,DefaultParameterSetName = 'Default')]
  Param (
    [Parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)][string]$HostName,
    [Parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $true, HelpMessage = 'A list of Host Types can be found on the screen Administration -> Passwordstate Administration -> Host Types and Operating Systems')][ValidateLength(0,50)][string]$HostType,
    [Parameter(ValueFromPipelineByPropertyName, Position = 2, Mandatory = $true, HelpMessage = 'A list of Operting Systems can be found on the screen Administration -> Passwordstate Administration -> Host Types and Operating Systems')][ValidateLength(0,50)][string]$OperatingSystem,
    [Parameter(ValueFromPipelineByPropertyName, Position = 3)][ValidateSet('MariaDB','MySQL','Oracle','PostgreSQL','SQL Server')][string]$DatabaseServerType,
    [Parameter(ValueFromPipelineByPropertyName, Position = 4)][ValidateLength(0,100)][string]$SQLInstanceName = '',
    [Parameter(ValueFromPipelineByPropertyName, Position = 5)][int32]$DatabasePortNumber,
    [Parameter(ValueFromPipelineByPropertyName, Position = 6, Mandatory = $true)][ValidateSet('RDP','SSH','Teamviewer','Telnet','VNC')][string]$RemoteConnectionType,
    [Parameter(ValueFromPipelineByPropertyName, Position = 7)][int32]$RemoteConnectionPortNumber,
    [Parameter(ValueFromPipelineByPropertyName, Position = 8)][ValidateLength(0,500)][string]$RemoteConnectionParameters = '',
    [Parameter(ValueFromPipelineByPropertyName, Position = 9)][ValidateLength(0,1000)][string]$Tag = '',
    [Parameter(ValueFromPipelineByPropertyName, Position = 10)][ValidateLength(0,200)][string]$Title = '',
    [Parameter(ValueFromPipelineByPropertyName, Position = 11)][int32]$SiteID = 0,
    [Parameter(ValueFromPipelineByPropertyName, Position = 12)][ValidateLength(0,50)][string]$InternalIP = '',
    [Parameter(ValueFromPipelineByPropertyName, Position = 13)][ValidateLength(0,50)][string]$ExternalIP = '',
    [Parameter(ValueFromPipelineByPropertyName, Position = 14)][ValidateLength(0,50)][string]$MACAddress = '',
    [Parameter(ValueFromPipelineByPropertyName, Position = 15)][switch]$SessionRecording,
    [Parameter(ValueFromPipelineByPropertyName, Position = 16, ParameterSetName = 'VM')][switch]$VirtualMachine,
    [Parameter(ValueFromPipelineByPropertyName, Position = 17, ParameterSetName = 'VM', Mandatory = $true)][ValidateSet('Amazon','Azure','HyperV','Virtualbox','VMware','Xen')][string]$VirtualMachineType,
    [Parameter(ValueFromPipelineByPropertyName, Position = 18)][string]$Notes = '',
    [Parameter(ValueFromPipelineByPropertyName, Position = 19)][switch]$PreventAuditing
  )

  Process
  {
    # Fix params
    If (!($RemoteConnectionPortNumber))
    {
      Switch ($RemoteConnectionType)
      {
        'RDP'        { $RemoteConnectionPortNumber = 3389 }
        'SSH'        { $RemoteConnectionPortNumber = 22 }
        'Teamviewer' { $RemoteConnectionPortNumber = 0 }
        'Telnet'     { $RemoteConnectionPortNumber = 23 }
        'VNC'        { $RemoteConnectionPortNumber = 5901 }
      }
    }

    $uri = ''
    If ($PreventAuditing.IsPresent)
    {
      $uri = '?PreventAuditing=true'
    }

    # Create the post object
    $Body = [PSCustomObject] @{
      'HostName'                   = $HostName
      'HostType'                   = $HostType
      'OperatingSystem'            = $OperatingSystem
      'DatabaseServerType'         = $DatabaseServerType
      'SQLInstanceName'            = $SQLInstanceName
      'DatabasePortNumber'         = $DatabasePortNumber
      'RemoteConnectionType'       = $RemoteConnectionType
      'RemoteConnectionPortNumber' = $RemoteConnectionPortNumber
      'RemoteConnectionParameters' = $RemoteConnectionParameters
      'Tag'                        = $Tag
      'Title'                      = $Title
      'SiteID'                     = $SiteID
      'InternalIP'                 = $InternalIP
      'ExternalIP'                 = $ExternalIP
      'MACAddress'                 = $MACAddress
      'SessionRecording'           = $SessionRecording.IsPresent
      'VirtualMachine'             = $VirtualMachine.IsPresent
      'VirtualMachineType'         = $VirtualMachineType
      'Notes'                      = $Notes
    }

    If ($PSCmdlet.ShouldProcess("$($HostName)"))
    {
      Try
      {
        New-PasswordStateResource -uri "/api/hosts/$($uri)" -body "$($Body | ConvertTo-Json)" -method POST
      }
      Catch
      {
        Throw $_.Exception
      }
    }
  }
}