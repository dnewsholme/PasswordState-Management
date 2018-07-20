<#
.SYNOPSIS
    Creates a New Password State entry in the password list specified.
.DESCRIPTION
    Creates a New Password State entry in the password list specified.
.EXAMPLE
    PS C:\> New-PasswordStatePassword -Title "testpassword" -PasswordListID 1 -username "newuser" -Password "CorrectHorseStapleBattery" -notes "development website" -url "http://somegoodwebsite.com"
    Creates a new password entry called testpassword
.PARAMETER passwordlistid
    The ID of the password list which to place the entry in. Int32 value.
.PARAMETER username
    The username to be added to the entry (Optional)
.PARAMETER password
    The password to be added to the entry.
.PARAMETER title
    Name of the entry to be created.
.PARAMETER notes
    Any notes to be added.
.PARAMETER url
    URL to be added to the entry if relevant.
.PARAMETER description
    custom description to be added to the password..
.INPUTS
    passwordlistID - The ID of the password list to create the password in. (Integer)
    username - Username for the entry (String)
    password - Password value for the entry (String)
    title - Title for the entry (String)
    notes - Notes for the entry (String)(Optional)
    url - URL for the entry (String)(Optional)
    description - description for entyr (Optional)
.OUTPUTS
    The entry is returned from the Password State Server.
.NOTES
    Daryl Newsholme 2018
#>
function New-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Password can only be passed to api in plaintext due to passwordstate api'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'Credential would break cmdlet flow')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName)][int32]$passwordlistID,
        [parameter(ValueFromPipelineByPropertyName)][string]$username = "",
        [parameter(ValueFromPipelineByPropertyName)][string]$description,
        [parameter(ValueFromPipelineByPropertyName)][string]$password,
        [parameter(ValueFromPipelineByPropertyName)][string]$title,
        [parameter(ValueFromPipelineByPropertyName)][string]$notes,
        [parameter(ValueFromPipelineByPropertyName)][string]$url
    )

    begin {
        # Check to see if the requested password entry exists before continuing.
        $result = Find-PasswordStatePassword -title "$title" -username $username
        if ($result.Username -eq $username) {
            throw "Found Existing Password Entry with Title:$title and username:$username"
        }
    }

    process {
        # Build the Custom object to convert to json and send to the api.
        if ($continue -ne $false) {
            $body = [pscustomobject]@{
                "PasswordListID" = $passwordListID
                "Username"       = $username
                "Description"    = $description
                "Password"       = $password
                "Title"          = $Title
                "Notes"          = $notes
                "URL"            = $url
            }
            if ($PSCmdlet.ShouldProcess("PasswordList:$passwordListID Title:$title Username:$username")) {
                $output = New-PasswordStateResource -uri "/api/passwords" -body "$($body|convertto-json)"
            }
        }
    }

    end {
        return $output
    }
}