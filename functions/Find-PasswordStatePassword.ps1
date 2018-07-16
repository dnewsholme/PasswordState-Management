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
.INPUTS
    Title - The title of the entry (string)
    Username - The username you need the password for. If multiple entries have the same name this is useful to get the one you want only. (String)(Optional)
.OUTPUTS
    Returns the Object from the API as a powershell object.
.NOTES
    Daryl Newsholme 2018
#>
function Find-PasswordStatePassword {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0)]$title,
        [parameter(ValueFromPipelineByPropertyName, Position = 1)]$username
    )
    begin {
        # Initialize the array for output
        $output = @()
    }

    process {
        # search each list for the password title (exclude the passwords so it doesn't spam audit logs with lots of read passwords)
        if (!$username) {
            try {
                $tempobj = Get-PasswordStateResource -uri "/api/searchpasswords/?search=$title&ExcludePassword=true" -ErrorAction stop
            }
            Catch [System.Net.WebException] {
                throw $_.Exception
            }
        }

        elseif ($username) {
            try {
                $tempobj = Get-PasswordStateResource -uri "/api/searchpasswords/?title=$title&username=$username&ExcludePassword=true" -ErrorAction Stop
                $tempobj = $tempobj | Where-Object {$_.Title -eq $title -and $_.Username -eq $username}

            }
            Catch [System.Net.WebException] {
                throw $_.Exception
            }
        }

        foreach ($item in $tempobj) {
            $obj = Get-PasswordStateResource -uri "/api/passwords/$($item.PasswordID)" -method GET
            $output += $obj
        }
    }

    end {
        # Use select to make sure output is returned in a sensible order.
        if ($output) {
            Return $output
        }
        Else {
            throw "No Password found for $title $username"
        }
    }
}