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