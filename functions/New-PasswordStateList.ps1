<#
.SYNOPSIS
Creates a passwordstate List.

.DESCRIPTION
Creates a passwordstate List.

.PARAMETER Name
Name of the Passwordstate list

.PARAMETER description
Description for the list

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
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$Name,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$description,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][int32]$CopySettingsFromPasswordListID,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][int32]$FolderID

    )

    begin {
        . "$(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordStateClass.ps1")"
    }
    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [pscustomobject]@{
            "PasswordList"                   = $Name
            "Description"                    = $description
            "CopySettingsFromPasswordListID" = $CopySettingsFromPasswordListID
            "NestUnderFolderID"              = $FolderID
            "LinkToTemplate" = $false
            "CopySettingsFromTemplateID" = ""
            "SiteID" = "0"
        }
        $penv = Get-PasswordStateEnvironment
        if ($penv.AuthType -eq "APIKey"){
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $penv.Apikey
        }
        if ($PSCmdlet.ShouldProcess("$Name under folder $folderid")) {
            $body = "$($body|convertto-json)"
            Write-Verbose "$body"
            $output = New-PasswordStateResource  -uri "/api/passwordlists" -body $body
        }
    }

    end {
        return $output
    }
}