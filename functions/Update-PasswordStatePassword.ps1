<#
.SYNOPSIS
    Updates the password of an existing password state entry.
.DESCRIPTION
    Updates the password of an existing password state entry.
.PARAMETER PasswordListID
    The password list in which the entry resides.
.PARAMETER PasswordID
    The ID of the password to be updated.
.PARAMETER title
    The title of the password to be updated.
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
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName)]$passwordlistID,
        [parameter(ValueFromPipelineByPropertyName)]$passwordID,
        [string]$password,
        [parameter(ValueFromPipelineByPropertyName)]$title
    )

    begin {
        $result = Get-PasswordStateResource  -uri "/api/passwords/$($PasswordListID)?QueryAll&ExcludePassword=true" | Where-Object {$_.Title -eq "$title"}
        if ($result.PasswordID -eq $passwordID) {
            Write-Verbose "Found Matching Password Entry"
            $continue = $true
        }
    }

    process {
        if ($continue -eq $true) {
            $body = [pscustomobject]@{
                "PasswordID" = $passwordID
                "Password"   = $password
            }
            $output = Set-PasswordStateResource -uri "/api/passwords" -body "$($body|convertto-json)"
        }
    }

    end {
        return $output
    }
}