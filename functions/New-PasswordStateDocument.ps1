<#
.SYNOPSIS
Adds a new document to an existing PasswordState Resource.

.DESCRIPTION
Adds a new document to an existing PasswordState Resource.

.PARAMETER ID
The ID of the resource to be updated.

.PARAMETER resourcetype
The resource type to add the document to.

.PARAMETER DocumentName
Name of the document when it's uploaded.

.PARAMETER DocumentDescription
Description to be added to the document.

.PARAMETER Path
File path to the document to be uploaded.

.EXAMPLE
New-PasswordStateDocument -ID 36 -resourcetype Password -DocumentName Testdoc.csv -DocumentDescription Important Document -Path C:\temp\1.csv

.EXAMPLE
Find-PasswordStatePassword test | New-PasswordStateDocument -resourcetype Password -DocumentName Testdoc.csv -DocumentDescription Important Document -Path C:\temp\1.csv


.NOTES
Daryl Newsholme 2018
#>
function New-PasswordStateDocument {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Alias("PasswordId")][parameter(ValueFromPipelineByPropertyName, Position = 0)][int32]$ID,
        [parameter(ValueFromPipelineByPropertyName, Position = 1)][ValidateSet(
            "password",
            "passwordlist",
            "folder"
        )][string]$resourcetype = "password",
        [parameter(ValueFromPipelineByPropertyName, Position = 2)][string]$DocumentName,
        [parameter(ValueFromPipelineByPropertyName, Position = 3)][string]$DocumentDescription = $null,
        [parameter(ValueFromPipelineByPropertyName, Position = 4)][string]$Path
    )

    begin {
        . "$(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordStateClass.ps1")"
        $output = @()
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($path, "upload $DocumentName on $resourcetype with id $ID")) {
                $output += New-PasswordStateResource `
                    -uri "/api/document/$($resourcetype)/$($ID)?DocumentName=$($documentname)&DocumentDescription=$($documentdescription)" `
                    -extraparams @{"InFile" = "$Path"} `
                    -contenttype 'multipart/form-data' `
                    -ErrorAction stop
            }
        }
        Catch {
            $_.Exception
        }

    }

    end {
        return $output
    }
}