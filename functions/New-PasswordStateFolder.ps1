function New-PasswordStateFolder {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password field.'
    )]
    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$Name,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$description,
        [parameter(ValueFromPipelineByPropertyName)][int32]$CopySettingsFromPasswordListID = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)][int32]$FolderID = 0

    )

    begin {
    }

    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [pscustomobject]@{
            "FolderName"                     = $Name
            "Description"                    = $description
            "CopySettingsFromPasswordListID" = $CopySettingsFromPasswordListID
            "NestUnderFolderID"              = $FolderID
        }
        if ($PSCmdlet.ShouldProcess("$Name under folder $folderID")) {
            $output = New-PasswordStateResource  -uri "/api/Folders" -body "$($body|convertto-json)"
        }
    }

    end {
        return $output
    }
}