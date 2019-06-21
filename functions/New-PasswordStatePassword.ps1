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
        [parameter(ValueFromPipelineByPropertyName)][int32]$passwordlistID,
        [parameter(ValueFromPipelineByPropertyName)][string]$username = "",
        [parameter(ValueFromPipelineByPropertyName)][string]$description,
        [parameter(ValueFromPipelineByPropertyName,ParameterSetName="password")][string]$password,
        [parameter(ValueFromPipelineByPropertyName,ParameterSetName="GeneratePassword")][switch]$GeneratePassword,
        [parameter(ValueFromPipelineByPropertyName)][string]$title,
        [parameter(ValueFromPipelineByPropertyName)][string]$notes,
        [parameter(ValueFromPipelineByPropertyName)][string]$url,
        [parameter(ValueFromPipelineByPropertyName)][hashtable]$genericfields
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
        # Check if hashtable has valid values
        IF($genericfields) {
            $genericfields.keys | ForEach-Object  {
                if(!($($_) -match "GenericField\d" -and [int]$($_ -replace "[^0-9]" , '') -le 10)){
                    throw "GenericField array is not between boundaries or has invalid key names GenericField[1-10]"
                }
            }
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

            if($genericfields){
                $genericfields.keys | ForEach-Object{
                    $body | add-member -notepropertyname $_ -notepropertyvalue $genericfields.Item($_)
                }
            }
            if ($password){
                $body | add-member -notepropertyname "Password" -notepropertyvalue $password
            }
            if ($GeneratePassword){
                $body | add-member -notepropertyname GeneratePassword -NotePropertyValue $true
            }
            if ($PSCmdlet.ShouldProcess("PasswordList:$passwordListID Title:$title Username:$username")) {
                [PasswordResult]$output = New-PasswordStateResource -uri "/api/passwords" -body "$($body|convertto-json)"
                foreach ($i in $output){
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