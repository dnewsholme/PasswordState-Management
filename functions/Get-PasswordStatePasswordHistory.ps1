<#
.SYNOPSIS
    Gets a password state entry historical password entries.
.DESCRIPTION
    Gets a password state entry historical password entries..
.PARAMETER PasswordID
    ID value of the entry to find history for. Int32 value
.PARAMETER Reason
    A reason which can be logged for auditing of why a password was retrieved.
.EXAMPLE
    Get-PasswordStatePassword -PasswordID 5
    Returns the test user object including password.
.INPUTS
    PasswordID - ID of the Password entry (Integer)
.OUTPUTS
    Returns the Object from the API as a powershell object.
.NOTES
    Daryl Newsholme 2018
#>
function Get-PasswordStatePasswordHistory {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
    )]
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0)][int32]$PasswordID,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $false)][string]$reason
    )

    begin {
    }

    process {
        if ($reason) {
            $headerreason = @{"Reason" = "$reason"}
        }
        $result = Get-PasswordStateResource -uri "/api/passwordhistory/$($PasswordID)" -extraparams @{"Headers" = $headerreason}

    }

    end {
        # Use select to make sure output is returned in a sensible order.
        Return $result
    }
}