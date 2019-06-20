<#
    .SYNOPSIS
    Finds a password state host and returns the object. If multiple matches it will return multiple entries.

    .DESCRIPTION
    Finds a password state host and returns the object. If multiple matches it will return multiple entries.

    .EXAMPLE
    PS C:\> Get-PasswordStateHost
    Returns all hosts you have access to.
    .EXAMPLE
    PS C:\> Get-PasswordStateHost 'testhost'
    Returns the test host object.
    .EXAMPLE
    PS C:\> Get-PasswordStateHost -OperatingSystem 'Windows Server 2012'
    Returns the hosts that are using the Windows Server 2012 operating system.
    .EXAMPLE
    PS C:\> Get-PasswordStateHost -DatabaseServerType 'SQL Server,Oracle'
    Returns the hosts that are of the database server type SQL Servers and Oracle

    .PARAMETER HostName
    An optional parameter to filter the search on hostname.
    .PARAMETER HostType
    An optional parameter to filter the search on type of host.
    .PARAMETER OperatingSystem
    An optional parameter to filter the search on operating system.
    .PARAMETER DatabaseServerType
    An optional parameter to filter the search on database server type.
    .PARAMETER SiteID
    An optional parameter to filter the search on the site ID.
    .PARAMETER SiteLocation
    An optional parameter to filter the search on the site location.

    .PARAMETER PreventAuditing
    An optional parameter to prevent logging this API call in the audit log (Can be overruled in PasswordState preferences).

    .OUTPUTS
    Returns the Object from the API as a powershell object.

    .NOTES
    2019 - Jarno Colombeen
#>
Function Get-PasswordStateHost
{
  [CmdletBinding()]
  Param
  (
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)][string]$HostName,
    [Parameter(ValueFromPipelineByPropertyName, Position = 1)][string]$HostType,
    [Parameter(ValueFromPipelineByPropertyName, Position = 2)][string]$OperatingSystem,
    [Parameter(ValueFromPipelineByPropertyName, Position = 3)][string]$DatabaseServerType,
    [Parameter(ValueFromPipelineByPropertyName, Position = 4)][int32]$SiteID,
    [Parameter(ValueFromPipelineByPropertyName, Position = 5)][string]$SiteLocation,
    [Parameter(ValueFromPipelineByPropertyName, Position = 6)][switch]$PreventAuditing
  )

  Process {
    $uri = "/api/hosts/"

    If ($PSBoundParameters.Count -gt 0)
    {
      $BuildURL = '?'
      If ($HostName) {                  $BuildURL += "HostName=$([System.Web.HttpUtility]::UrlEncode($HostName))&" }
      If ($HostType) {                  $BuildURL += "HostType=$([System.Web.HttpUtility]::UrlEncode($HostType))&" }
      If ($OperatingSystem) {           $BuildURL += "OperatingSystem=$([System.Web.HttpUtility]::UrlEncode($OperatingSystem))&" }
      If ($DatabaseServerType) {        $BuildURL += "DatabaseServerType=$([System.Web.HttpUtility]::UrlEncode($DatabaseServerType))&" }
      If ($SiteID) {                    $BuildURL += "SiteID=$([System.Web.HttpUtility]::UrlEncode($SiteID))&" }
      If ($SiteLocation) {              $BuildURL += "SiteLocation=$([System.Web.HttpUtility]::UrlEncode($SiteLocation))&" }
      If ($PreventAuditing.IsPresent) { $BuildURL += "PreventAuditing=true&" }

      $uri += ($BuildURL -Replace ".$")
    }

    Try
    {
      Get-PasswordStateResource -URI $uri -Method GET
    }
    Catch
    {
      Throw $_.Exception
    }
  }
}