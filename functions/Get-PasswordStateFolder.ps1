<#
  .SYNOPSIS
  Finds a password state entry and returns the object. If multiple matches it will return multiple entries.
  .DESCRIPTION
  Finds a password state entry and returns the object. If multiple matches it will return multiple entries.

  .PARAMETER FolderName
  The name for the folder to find
  .PARAMETER Description
  The description for the folder to find
  .PARAMETER TreePath
  The treepath where the folder should be found
  .PARAMETER SiteID
  The siteID for the folder
  .PARAMETER SiteLocation
  The sitelocation for the folder

  .EXAMPLE
  PS C:\> Find-PasswordStateFolder -FolderName "test"
  Returns the test folder object.
  .EXAMPLE
  PS C:\> Find-PasswordStateFolder -Description "testfolder"
  Returns the folder objects that contain testfolder in the description.

  .OUTPUTS
  Returns the Object from the API as a powershell object.
  .NOTES
  2018 - Daryl Newsholme
  2019 - Jarno Colombeen
#>
Function Get-PasswordStateFolder {
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)][Alias('Name')][string]$FolderName,
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)][string]$Description,
        [Parameter(ValueFromPipelineByPropertyName, Position = 2)][string]$TreePath,
        [Parameter(ValueFromPipelineByPropertyName, Position = 3)][int32]$SiteID,
        [Parameter(ValueFromPipelineByPropertyName, Position = 4)][string]$SiteLocation,
        [parameter(ValueFromPipelineByPropertyName, Position = 5)][switch]$PreventAuditing
    )

    Process {
        If ($PSBoundParameters.Count -eq 0) {
            $uri = "/api/folders"
        }
        Else {
            $BuildURL = '?'
            If ($FolderName) {   $BuildURL += "FolderName=$([System.Web.HttpUtility]::UrlEncode($FolderName))&" }
            If ($Description) {  $BuildURL += "Description=$([System.Web.HttpUtility]::UrlEncode($Description))&" }
            If ($TreePath) {     $BuildURL += "TreePath=$([System.Web.HttpUtility]::UrlEncode($TreePath))&" }
            If ($SiteID) {       $BuildURL += "SiteID=$([System.Web.HttpUtility]::UrlEncode($SiteID))&" }
            If ($SiteLocation) { $BuildURL += "SiteLocation=$([System.Web.HttpUtility]::UrlEncode($SiteLocation))&" }

            $BuildURL = $BuildURL -Replace ".$"

            $uri = "/api/folders/$($BuildURL)"
        }
        Switch ($PreventAuditing) {
            $True {
                $uri += "&PreventAuditing=true"
            }
            Default {

            }
        }
        Try {
            Get-PasswordStateResource -uri $uri -method GET
        }
        Catch {
            Throw $_.Exception
        }
    }
}
