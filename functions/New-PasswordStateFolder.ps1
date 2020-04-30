function New-PasswordStateFolder {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password field.'
    )]
    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)][string]$Name,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $true)][string]$Description,
        [parameter(ValueFromPipelineByPropertyName, Position = 3, Mandatory = $false)][string]$CopyPermissionsFromPasswordListID = $null,
        [parameter(ValueFromPipelineByPropertyName, Position = 4, Mandatory = $false)][string]$CopyPermissionsFromTemplateID = $null,
        [parameter(ValueFromPipelineByPropertyName, Position = 2, Mandatory = $false, HelpMessage = "FolderID 0 = Folder will be created in the root of the Navigation Tree")][Alias("NestUnderFolderID")][int32]$FolderID = 0,
        [parameter(ValueFromPipelineByPropertyName, Position = 5, Mandatory = $false)][string]$Guide,
        [parameter(ValueFromPipelineByPropertyName, Position = 7, Mandatory = $false, HelpMessage = "SiteID 0 = Default site 'Internal'")][int32]$SiteID = 0,
        [parameter(ValueFromPipelineByPropertyName, Position = 6, Mandatory = $false)][switch]$PropagatePermissions
    )

    begin {
    }

    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [PSCustomObject]@{
            "FolderName"                        = $Name
            "Description"                       = $Description
            "NestUnderFolderID"                 = $FolderID
            "SiteID"                            = $SiteID
            "CopyPermissionsFromPasswordListID" = $CopyPermissionsFromPasswordListID
            "CopyPermissionsFromTemplateID"     = $CopyPermissionsFromTemplateID
        }

        # Any associated instructions (guide) for how the Folder should be used (Can contain HTML characters).
        if ($Guide) {
            # just in case someone is adding html code to the guide for whatever reason (HTML rendering is not allowed in the guide anymore on PasswordState)
            $Guide = [System.Net.WebUtility]::HtmlEncode($Guide)
            $body | Add-Member -NotePropertyName "Guide" -NotePropertyValue $Guide
        }
        # If you want the folder to propagate its permissions down to all nested Password Lists and Folders, then you set PropagatePermissions to true.
        if ($PropagatePermissions) {
            $body | Add-Member -NotePropertyName "PropagatePermissions" -NotePropertyValue $true
        }

        # Adding API Key to the body if using APIKey as Authentication Type to use the api instead of winAPI
        $penv = Get-PasswordStateEnvironment
        if ($penv.AuthType -eq "APIKey") {
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $penv.Apikey
        }

        if ($PSCmdlet.ShouldProcess("$Name under folder $FolderID")) {
            $body = "$($body|ConvertTo-Json)"
            $output = New-PasswordStateResource -uri "/api/folders" -body $body
        }
    }

    end {
        return $output
    }
}