<#
.SYNOPSIS
    Deletes a password state entry.
.DESCRIPTION
    Deletes a password state entry.
.PARAMETER PasswordID
    ID value of the entry to delete. Int32 value
.PARAMETER sendtorecyclebin
    Send the password to the recyclebin or permenant delete.
.EXAMPLE
    PS C:\> Remove-PasswordStatePassword -PasswordID 5 -sendtorecyclebin
    Returns the test user object including password.
.INPUTS
    PasswordID - ID of the Password entry (Integer)
    SendtoRecyclebin - Optionally soft delete to the reyclebin
.OUTPUTS
    Returns the Object from the API as a powershell object.
.NOTES
    Daryl Newsholme 2018
#>
function Remove-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
    )]
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName)]$PasswordID,
        [Switch]$SendToRecycleBin
    )

    begin {
    }

    process {
        if ($SendToRecycleBin) {
            $result = Remove-PasswordStateResource -uri "/api/passwords/$($PasswordID)?MoveToRecycleBin=$sendtorecyclebin"
        }
        Else {
            $result = Remove-PasswordStateResource -uri "/api/passwords/$($PasswordID)?MoveToRecycleBin=False"
        }
    }

    end {
        # Use select to make sure output is returned in a sensible order.
        Return $result
    }
}