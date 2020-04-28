function New-PasswordStateFolder
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password field.'
    )]
    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$Name,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$Description,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)][int32]$CopyPermissionsFromPasswordListID = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)][int32]$CopyPermissionsFromTemplateID = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, HelpMessage = "FolderID 0 = Folder will be created in the root of the Navigation Tree")][Alias("NestUnderFolderID")][int32]$FolderID = 0,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)][string]$Guide,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, HelpMessage = "SiteID 0 = Default site 'Internal'")][int32]$SiteID = 0,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)][switch]$PropagatePermissions
    )

    begin
    {
    }

    process
    {
        # Build the Custom object to convert to json and send to the api.
        $body = [PSCustomObject]@{
            "FolderName"        = $Name
            "Description"       = $Description
            "NestUnderFolderID" = $FolderID
            "SiteID"            = $SiteID
        }

        # To copy permissions to the Folder from an existing Password List, you can specify the PasswordListID value for this field.
        if ($CopyPermissionsFromPasswordListID)
        {
            $body | Add-Member -NotePropertyName "CopyPermissionsFromPasswordListID" -NotePropertyValue $CopyPermissionsFromPasswordListID
        }
        # To copy permissions to the Folder from an existing Password List Template, you can specify the TemplateID value for this field.
        if ($CopyPermissionsFromTemplateID)
        {
            $body | Add-Member -NotePropertyName "CopyPermissionsFromTemplateID" -NotePropertyValue $CopyPermissionsFromTemplateID
        }
        # Any associated instructions (guide) for how the Folder should be used (Can contain HTML characters).
        if ($Guide)
        {
            # just in case someone is adding html code to the guide for whatever reason (HTML rendering is not allowed  in the guide anymore on PasswordState)
            $Guide = [System.Net.WebUtility]::HtmlEncode($Guide)
            $body | Add-Member -NotePropertyName "Guide" -NotePropertyValue $Guide
        }
        # If you want the folder to propagate its permissions down to all nested Password Lists and Folders, then you set PropagatePermissions to true.
        # This option can only be enabled for top level folders i.e. nested under Passwords Home.
        if ($PropagatePermissions)
        {
            $body | Add-Member -NotePropertyName "PropagatePermissions" -NotePropertyValue $PropagatePermissions
        }

        # Adding API Key to the body if using APIKey as Authentication Type to use the api instead of winAPI
        $penv = Get-PasswordStateEnvironment
        if ($penv.AuthType -eq "APIKey")
        {
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $penv.Apikey
        }

        if ($PSCmdlet.ShouldProcess("$Name under folder $FolderID"))
        {
            $body = "$($body|ConvertTo-Json)"
            Write-Verbose "$body"
            $output = New-PasswordStateResource -uri "/api/folders" -body $body
        }
    }

    end
    {
        return $output
    }
}