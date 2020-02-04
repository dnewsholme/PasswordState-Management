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