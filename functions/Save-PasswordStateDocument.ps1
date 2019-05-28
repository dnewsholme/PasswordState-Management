<#
.SYNOPSIS
Adds a new document to an existing PasswordState Resource.

.DESCRIPTION
Adds a new document to an existing PasswordState Resource.

.PARAMETER resourcetype
The resource type to add the document to.

.PARAMETER Path
File path to the document to be uploaded.

.EXAMPLE
Save-PasswordStateDocument -DocumentID 36 -resourcetype Password -Path C:\temp\1.csv

.EXAMPLE
Find-PasswordStatePassword test | Save-PasswordStateDocument -Path C:\temp\1.csv

.NOTES
Daryl Newsholme 2018
#>
function Save-PasswordStateDocument {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 1)][ValidateSet(
            "password",
            "passwordlist",
            "folder"
        )][string]$resourcetype = "password",
        [parameter(ValueFromPipelineByPropertyName, Position = 2)][int32]$DocumentID,
        [parameter(ValueFromPipelineByPropertyName, Position = 4)][string]$Path
    )

    begin {
        . "$(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordStateClass.ps1")"
        $output = @()
    }

    process {
        try {
            $output += Get-PasswordStateResource `
                -uri "/api/document/$($resourcetype)/$($ID)/$documentID" `
                -extraparams @{"OutFile" = "$Path"} `
                -contenttype 'multipart/form-data' `
                -ErrorAction stop
        }
        Catch {
            $_.Exception
        }

    }

    end {
        return (Get-Item $Path)
    }
}