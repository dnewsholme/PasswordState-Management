<#
.SYNOPSIS
    Creates a New Password State entry in the password list specified.
.DESCRIPTION
    Creates a New Password State entry in the password list specified.
.EXAMPLE
    PS C:\> New-PasswordStatePassword -Title "testpassword" -PasswordListID 1 -username "newuser" -Password "CorrectHorseStapleBattery" -notes "development website" -url "http://somegoodwebsite.com" -customfields @{GenericField1 = 'value for GenericField1';GenericField2 = 'value2'}
    Creates a new password entry called testpassword
.PARAMETER passwordlistid
    The ID of the password list which to place the entry in. Int32 value.
.PARAMETER username
    The username to be added to the entry (Optional)
.PARAMETER password
    The password to be added to the entry.
.PARAMETER Generatepassword
    A switch parameter to generate the password based off the PasswordList Policy.
.PARAMETER title
    Name of the entry to be created.
.PARAMETER notes
    Any notes to be added.
.PARAMETER url
    URL to be added to the entry if relevant.
.PARAMETER description
    custom description to be added to the password..
.PARAMETER GenericFields
    Hashtable with a key/value pair, that accepts GenercFields1-10 as the key, with any value. Can be omitted
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
    Willem R 2019
#>
function New-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Password can only be passed to api in plaintext due to passwordstate api'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'Credential would break cmdlet flow')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Needed for backward compatability')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, Position = 0)][int32]$passwordlistID,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, Position = 1)][string]$title,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 2)][string]$username = "",
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "password", Position = 3)][string]$password,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 4)][string]$description,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "GeneratePassword", Position = 5)][switch]$GeneratePassword,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 6)][string]$notes,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 7)][string]$url,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 8)][string]$GenericField1 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 10)][string]$GenericField2 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 11)][string]$GenericField3 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 12)][string]$GenericField4 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 13)][string]$GenericField5 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 14)][string]$GenericField6 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 15)][string]$GenericField7 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 16)][string]$GenericField8 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 17)][string]$GenericField9 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 18)][string]$GenericField10 = $null
    )

    begin {
        . "$(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordStateClass.ps1")"
        # Check to see if the requested password entry exists before continuing.
        try {
            $result = Get-PasswordStatePassword -title "$title" -username $username -ErrorAction stop
        }
        Catch {
            Write-Verbose "No existing password...Continuing."
        }
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
                "Title"          = $Title
                "Notes"          = $notes
                "URL"            = $url
            }

            try {
                $genericfields = Get-Variable genericfield* | Where-Object {$_.Value -ne [NullString] -and $null -ne $_.Value}
            }
            Catch {
                Write-Verbose "[$(Get-Date -format G)] no generic fields specified"
            }
            if ($genericfields) {
                $genericfields | ForEach-Object {
                    $body | add-member -notepropertyname $_.Name -notepropertyvalue $_.Value
                }
            }
            if ($password) {
                $body | add-member -notepropertyname "Password" -notepropertyvalue $password
            }
            if ($GeneratePassword) {
                $body | add-member -notepropertyname GeneratePassword -NotePropertyValue $true
            }
            if ($PSCmdlet.ShouldProcess("PasswordList:$passwordListID Title:$title Username:$username")) {
                [PasswordResult]$output = New-PasswordStateResource -uri "/passwords" -body "$($body|convertto-json)"
                foreach ($i in $output) {
                    $i.Password = [EncryptedPassword]$i.Password
                }
            }
        }
    }

    end {
        switch ($global:PasswordStateShowPasswordsPlainText) {
            True {
                $output.DecryptPassword()
            }
        }
        Return $output
    }
}