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
    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$Name,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$description,
        [parameter(ValueFromPipelineByPropertyName)][int32]$CopySettingsFromPasswordListID = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)][int32]$FolderID = 0

    )

    begin {
        . "$(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordStateClass.ps1")"
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