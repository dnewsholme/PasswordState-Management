<#
.SYNOPSIS
Creates a passwordstate Folder.

.DESCRIPTION
Creates a passwordstate Folder.

.PARAMETER Name
Name of the Passwordstate Folder

.PARAMETER description
Description fro the Folder

.PARAMETER CopySettingsFromPasswordFolderID
Optionally copy the settings from another Folder.

.PARAMETER FolderID
Folder ID that the Folder should be placed under. Will default to root if left blank

.EXAMPLE
New-PasswordStateFolder -Name TestFolder -Description "A Test Folder" -FolderID 4

.NOTES
Daryl Newsholme 2018
#>
function New-PasswordStateFolder {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password field.'
    )]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)]$Name,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)]$description,
        [parameter(ValueFromPipelineByPropertyName)]$CopySettingsFromPasswordListID = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]$FolderID = 0

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
        $output = New-PasswordStateResource  -uri "/api/Folders" -body "$($body|convertto-json)"
    }

    end {
        return $output
    }
}