<#
.SYNOPSIS
    Updates the password of an existing password state entry.
.DESCRIPTION
    Updates the password of an existing password state entry.
.PARAMETER PasswordID
    The ID of the password to be updated.
.PARAMETER Password
    The new password to be added to the entry.
.EXAMPLE
    PS C:\> Update-PasswordStatePassword -PasswordlistID 5 -PasswordID 1 -Password "76y288uneeko%%%2A" -title "testuser01"
    Updates the password to "76y288uneeko%%%2A" for the entry named testuser01
.INPUTS
    All fields must be specified, can be passed along the pipeline.
.OUTPUTS
    Will output all fields for the entry from passwordstate including the new password.
.NOTES
    Daryl Newsholme 2018
#>
function Update-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'API requires password be passed as plain text'
    )]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][int32]$passwordID,
        [parameter(Mandatory = $true)][string]$password
    )

    begin {

    }

    process {
        if ($passwordID) {
            try {
                $result = Find-PasswordStatePassword -PasswordID $passwordID -ErrorAction Stop
                Write-Verbose "[$(Get-Date -format G)] updating $($result.title)"
            }
            Catch {
                throw "Password ID $passwordID not found"
            }
        }
        else {
            throw "Must use password ID to update passwords"
        }
        if ($PSCmdlet.ShouldProcess("PasswordID:$($result.PasswordID) Title:$($result.title)")) {
            $body = [pscustomobject]@{
                "PasswordID" = $result.passwordID
                "Password"   = $password
            }

            $output = Set-PasswordStateResource -uri "/api/passwords" -body "$($body|convertto-json)"
        }

    }

    end {
        return $output
    }
}