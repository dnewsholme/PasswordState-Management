Function Get-PasswordStateFolder {
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)][Alias('Name')][string]$FolderName,
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)][string]$Description,
        [Parameter(ValueFromPipelineByPropertyName, Position = 2)][string]$TreePath,
        [Parameter(ValueFromPipelineByPropertyName, Position = 3)][AllowNull()][Nullable[System.Int32]]$SiteID = 0,
        [Parameter(ValueFromPipelineByPropertyName, Position = 4)][string]$SiteLocation,
        [parameter(ValueFromPipelineByPropertyName, Position = 6)][Nullable[System.Int32]]$FolderID,
        [parameter(ValueFromPipelineByPropertyName, Position = 7)][switch]$PreventAuditing,
        [parameter(ValueFromPipelineByPropertyName, Position = 8)][string]$Reason
    )

    Begin {
        # Add a reason to the audit log if specified
        if ($Reason) {
            $headerreason = @{"Reason" = "$Reason" }
            $parms = @{ExtraParams = @{"Headers" = $headerreason } }
        }
        else { $parms = @{ } }
    }

    Process {
        if ($PSBoundParameters.Count -eq 0) {
            $uri = "/api/folders"
        }
        elseif ($PSBoundParameters.ContainsKey('FolderID')) {
            $uri = "/api/folders"
            if ($PreventAuditing) {
                $uri += "&PreventAuditing=true"
            }
            try {
                $result = Get-PasswordStateResource -uri $uri @parms -ErrorAction Stop | Where-Object { $_.FolderID -eq $FolderID }
            }
            catch {
                throw $_.Exception
            }
            if ($result) {
                return $result
            }
            else {
                throw "You search for folder records with FolderID '$FolderID' return zero results."
            }
        }
        else {
            $BuildURL = '?'
            if ($FolderName) { $BuildURL += "FolderName=$([System.Web.HttpUtility]::UrlEncode($FolderName))&" }
            if ($Description) { $BuildURL += "Description=$([System.Web.HttpUtility]::UrlEncode($Description))&" }
            if ($TreePath) { $BuildURL += "TreePath=$([System.Web.HttpUtility]::UrlEncode($TreePath))&" }
            if ($SiteID) { $BuildURL += "SiteID=$([System.Web.HttpUtility]::UrlEncode($SiteID))&" }
            if ($SiteLocation) { $BuildURL += "SiteLocation=$([System.Web.HttpUtility]::UrlEncode($SiteLocation))&" }

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
            Get-PasswordStateResource -uri $uri @parms -ErrorAction Stop
        }
        Catch {
            throw $_.Exception
        }
    }
}

Set-Alias -Name Find-PasswordStateListFolder -Value Get-PasswordStateFolder -Force
