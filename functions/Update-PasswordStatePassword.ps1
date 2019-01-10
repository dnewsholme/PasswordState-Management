<#
.SYNOPSIS
    Updates the password of an existing password state entry.
.DESCRIPTION
    Updates the password of an existing password state entry. Any fields not sent will remain the same as before.
.PARAMETER PasswordID
    The ID of the password to be updated.
.PARAMETER Password
    The new password to be added to the entry.
.PARAMETER title
    Updated title value
.PARAMETER username
    Updated username Value
.PARAMETER domain
    Updated domain value
.PARAMETER hostname
    Updated hostname value
.PARAMETER notes
    Updated note value
.PARAMETER url
    Updated URL value
.PARAMETER Reason
    A reason which can be logged for auditing of why a password was updated.
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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'API requires password be passed as plain text')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'API requires password be passed as plain text')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [parameter(Position = 0, ValueFromPipelineByPropertyName, Mandatory = $true)][int32]$passwordID,
        [parameter(Position = 1, ValueFromPipelineByPropertyName, Mandatory = $false)][string]$password,
        [parameter(Position = 2, ValueFromPipelineByPropertyName, Mandatory = $false)][string]$title,
        [parameter(Position = 3, ValueFromPipelineByPropertyName, Mandatory = $false)][string]$username,
        [parameter(Position = 4, ValueFromPipelineByPropertyName, Mandatory = $false)][string]$domain,
        [parameter(Position = 5, ValueFromPipelineByPropertyName, Mandatory = $false)][string]$hostname,
        [parameter(Position = 6, ValueFromPipelineByPropertyName, Mandatory = $false)][string]$notes,
        [parameter(Position = 7, ValueFromPipelineByPropertyName, Mandatory = $false)][string]$url,
        [parameter(Position = 8, ValueFromPipelineByPropertyName, Mandatory = $false)][string]$reason
    )

    begin {

    }

    process {
        if ($reason) {
            $headerreason = @{"Reason" = "$reason"}
        }
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
            # Loop through each of the bound parameters and set the updated value on the object.
            foreach ($i in $PSBoundParameters.Keys) {
                # Replace Result property with that of the bound parameter
                $notprocess = "reason", "verbose", "erroraction", "debug", "whatif", "confirm"
                if ($notprocess -notcontains $i) {
                    $result.$($i) = $PSBoundParameters.$($i)
                }
            }
            # Store in a new variable and remove all null values as password state doesn't like nulls.
            $body = $result
            # Initialize array for the select statement later
            $selections = @()
            # Get all properties from the object.
            $properties = ($body | Get-Member -Force | Where-Object {$_.MemberType -eq "Property"}).Name
            # Get only those properties which aren't empty and add them to our selection array.
            foreach ($item in $properties) {
                if ($body.$($item) -notlike $null) {
                    $selections += $item
                }
            }
            # Update body variable to contain only the properties with data.
            $body = $body | Select-Object $selections
            # Write back to password state.
            $output = Set-PasswordStateResource -uri "/api/passwords" -body "$($body|convertto-json)" -extraparams @{"Headers" = $headerreason}
        }

    }

    end {
        return $output
    }
}