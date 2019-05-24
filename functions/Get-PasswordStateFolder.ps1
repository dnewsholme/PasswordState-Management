<#
.SYNOPSIS
    Finds a password state entry and returns the object. If multiple matches it will return multiple entries.
.DESCRIPTION
    Finds a password state entry and returns the object. If multiple matches it will return multiple entries.
.EXAMPLE
    PS C:\> Find-PasswordStateFolder -Name "test"
    Returns the test folder object.
.PARAMETER Name
    A string value which should match the passwordstate entry exactly(Not case sensitive)

.INPUTS
    Name - The title of the entry (string)
.OUTPUTS
    Returns the Object from the API as a powershell object.
.NOTES
    Daryl Newsholme 2018
#>
function Get-PasswordStateFolder {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 1)][string]$Name
    )
    begin {
        . $(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordstateClass.ps1")
        # Initialize the array for output
        $output = @()
    }

    process {
        # search each list for the password title (exclude the passwords so it doesn't spam audit logs with lots of read passwords)
        try {
            $output = Get-PasswordStateResource -uri "/api/folders/?FolderName=$Name" -ErrorAction stop
        }
        Catch [System.Net.WebException] {
            throw $_.Exception
        }
    }

    end {
        # Use select to make sure output is returned in a sensible order.
        if ($output) {
            Return $output
        }
    }
}