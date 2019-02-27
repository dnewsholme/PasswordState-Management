<#
.SYNOPSIS
    Gets All PasswordStatePasswords from a list, based on ID. Use Get-PasswordStateList to search for a name and return the ID
.DESCRIPTION
    Gets All PasswordStatePasswords from a list, based on ID. Use Get-PasswordStateList to search for a name and return the ID
.EXAMPLE
    PS C:\> Get-PasswordStatePassword -PasswordListID 1
    Returns all user objects including password.
.PARAMETER PasswordListID
    An ID of a specific passwordlist resource to return.
.NOTES
    Willem R 2019
#>
function Get-PasswordStatePasswords {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'No Password is used only ID.'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'PasswordID isnt a password')]
    param (
        [Parameter(ParameterSetName='GetAllPasswordsFromList', Mandatory = $false)][int32]$PasswordlistID
    )

    begin {
    }

    process {
        $output = Get-PasswordStateResource -uri $("/api/passwords/" + $PasswordlistID + "?QueryAll")
    }

    end {
    return $output
    }
}