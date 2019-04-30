<#
.SYNOPSIS
    Finds a password state entry and returns the object. If multiple matches it will return multiple entries.
.DESCRIPTION
    Finds a password state entry and returns the object. If multiple matches it will return multiple entries.
.EXAMPLE
    PS C:\> Find-PasswordStatePassword -title "testuser"
    Returns the test user object including password.
.PARAMETER title
    A string value which should match the passwordstate entry exactly(Not case sensitive)
.PARAMETER Username
    An optional parameter to filter searches to those with a certain username as multiple titles may have the same value.
.PARAMETER PasswordID
    An ID of a specific password resource to return.
.PARAMETER Reason
    A reason which can be logged for auditing of why a password was retrieved.
.INPUTS
    Title - The title of the entry (string)
    Username - The username you need the password for. If multiple entries have the same name this is useful to get the one you want only. (String)(Optional)
.OUTPUTS
    Returns the Object from the API as a powershell object.
.NOTES
    Daryl Newsholme 2018
#>
function Find-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'No Password is used only ID.'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'PasswordID isnt a password')]
    [CmdletBinding(DefaultParameterSetName = "1")]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 1)][string]$title,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 1)][string]$username,
        [parameter(ValueFromPipelineByPropertyName, Position = 2, ParameterSetName = 2)][int32]$PasswordID,
        [parameter(ValueFromPipelineByPropertyName, Position = 3, ParameterSetName = 1)][switch]$exactmatchonly,
        [parameter(ValueFromPipelineByPropertyName, Position = 4, Mandatory = $false)][string]$reason
    )
    begin {
        # Create Class
        class PasswordResult {
            # Properties
            [int]$PasswordID
            [String]$Title
            [String]$Username
            [String]$Password
            [String]$Description
            [String]$Domain
            # Hidden Properties
            hidden [String]$hostname
            hidden [String]$GenericField1
            hidden [String]$GenericField2
            hidden [String]$GenericField3
            hidden [String]$GenericField4
            hidden [String]$GenericField5
            hidden [String]$GenericField6
            hidden [String]$GenericField7
            hidden [String]$GenericField8
            hidden [String]$GenericField9
            hidden [String]$GenericField10
            hidden [int]$AccountTypeID
            hidden [string]$notes
            hidden [string]$URL
            hidden [string]$ExpiryDate
            hidden [string]$allowExport
            hidden [string]$accounttype

        }
        #Initalize output Array
        $output = @()
    }

    process {
        if ($reason) {
            $headerreason = @{"Reason" = "$reason"}
        }
        # search each list for the password title (exclude the passwords so it doesn't spam audit logs with lots of read passwords)
        if ($PasswordID) {
            $tempobj = [PSCustomObject]@{
                PasswordID = $PasswordID
            }
        }
        elseif (!$username) {
            try {
                $tempobj = Get-PasswordStateResource -uri "/api/searchpasswords/?search=$title&ExcludePassword=true"  -ErrorAction stop
            }
            Catch [System.Net.WebException] {
                throw $_.Exception
            }
        }

        elseif ($username) {
            try {
                $tempobj = Get-PasswordStateResource -uri "/api/searchpasswords/?username=$username&ExcludePassword=true"  -ErrorAction Stop

            }
            Catch [System.Net.WebException] {
                throw $_.Exception
            }
        }

        foreach ($item in $tempobj) {
            [PasswordResult]$obj = Get-PasswordStateResource -uri "/api/passwords/$($item.PasswordID)" -extraparams @{"Headers" = $headerreason} -method GET
            $output += $obj
        }
    }

    end {
        if ($output -and $exactmatchonly -eq $true) {
            Return $output | Where-Object {$_.title -eq $title}
        }
        elseif ($output) {
            Return $output
        }
        Else {
            throw "No Password found for $passwordID $title $username"
        }
    }
}
