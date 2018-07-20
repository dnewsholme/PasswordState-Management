<#
.SYNOPSIS
Creates a passwordstate List.

.DESCRIPTION
Creates a passwordstate List.

.PARAMETER Name
Name of the Passwordstate list

.PARAMETER description
Description fro the list

.PARAMETER CopySettingsFromPasswordListID
Optionally copy the settings from another list.

.PARAMETER FolderID
Folder ID that the list should be placed under

.EXAMPLE
New-PasswordStateList -Name TestList -Description "A Test List" -FolderID 4

.NOTES
Daryl Newsholme 2018
#>
function New-PasswordStateList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password field.'
    )]
    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string[]]$Name,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string[]]$description,
        [parameter(ValueFromPipelineByPropertyName)][int32[]]$CopySettingsFromPasswordListID = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][int32[]]$FolderID

    )

    begin {

    }

    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [pscustomobject]@{
            "PasswordList"                   = $Name
            "Description"                    = $description
            "CopySettingsFromPasswordListID" = $CopySettingsFromPasswordListID
            "NestUnderFolderID"              = $FolderID
        }
        if ($PSCmdlet.ShouldProcess("$Name under folder $folderid")) {
            $output = New-PasswordStateResource  -uri "/api/passwordlists" -body "$($body|convertto-json)"
        }
    }

    end {
        return $output
    }
}