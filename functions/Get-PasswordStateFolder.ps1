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

Set-Alias -Name Find-PasswordStateListFolder -Value Get-PasswordStateFolder -Force
