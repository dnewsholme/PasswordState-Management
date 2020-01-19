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
                [PasswordResult]$output = New-PasswordStateResource -uri "/api/passwords" -body "$($body|convertto-json)"
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