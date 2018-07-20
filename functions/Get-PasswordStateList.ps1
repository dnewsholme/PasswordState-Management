<#
.SYNOPSIS
    Gets all password lists from the API (Only those you have permissions to.)
.DESCRIPTION
    Gets all password lists from the API (Only those you have permissions to.)
.EXAMPLE
    PS C:\> Get-PasswordStateList
.OUTPUTS
    Returns the lists including their names and IDs.
.NOTES
    Daryl Newsholme 2018
#>
function Get-PasswordStateList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
    )]
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0)][int32[]]$PasswordListID
    )

    begin {
    }

    process {
        # Get all lists from the API
        if (!$PasswordListID) {
            $lists = Get-PasswordStateResource -uri "/api/passwordlists"
        }
        else {
            $lists = Get-PasswordStateResource -uri "/api/passwordlists/$passwordListID"
        }
    }

    end {
        return $lists
    }
}