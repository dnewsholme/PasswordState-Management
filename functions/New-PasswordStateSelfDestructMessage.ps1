function New-PasswordStateSelfDestructMessage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password field.')]
    [cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $false)]
        [Nullable[System.Int32]]$PasswordID,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $false)]
        [string]$Message,
        [parameter(ValueFromPipelineByPropertyName, Position = 2, Mandatory = $false)]
        [string]$PrefixMessageContent,
        [parameter(ValueFromPipelineByPropertyName, Position = 3, Mandatory = $false)]
        [string]$AppendMessageContent,
        [parameter(ValueFromPipelineByPropertyName, Position = 4, Mandatory = $false)]
        [ValidateScript( {
                if ($_ -notmatch '^[0-9]{1,4}d|m|h$') {
                    throw "Given ExpiresAt '$_' is not a ExpiresAt format! Please specify a correct duration/time period as per the following examples: 30m (30 minutes), 3h (3 hours), or 2d (2 days)"
                }
                else {
                    $true
                }
            })]
        [string]$ExpiresAt = "1d",
        [parameter(ValueFromPipelineByPropertyName, Position = 5, Mandatory = $false)]
        [int32]$NoViews = 1,
        [parameter(ValueFromPipelineByPropertyName, Position = 6, Mandatory = $true)]
        [ValidateScript( {
                if ($_ -notmatch '^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$') {
                    throw "Given ToEmailAddress '$_' is not a valid mail address! Please specify a correct mail address, e.g. user@example.com, surname.lastname@example.com etc."
                }
                else {
                    $true
                }
            })]
        [string]$ToEmailAddress,
        [parameter(ValueFromPipelineByPropertyName, Position = 7, Mandatory = $false)]
        [ValidateScript( {
                # Exclude german umlauts and other latin/non-latin diacritics or invalid characters that the api does not understand.
                $InvalidChars = 'ßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ'
                $regex = [Regex]::Escape($InvalidChars)
                $regex = "[$regex]"
                $Invalid = [Regex]::Matches($_, $regex, 'IgnoreCase') | Select-Object -ExpandProperty Value | Sort-Object -Unique
                if ($null -ne $Invalid) {
                    throw "ERROR: The specified FirstName contains the following illegal characters: '$Invalid'. Please do not use the characters '$InvalidChars' for the FirstName since the api does not understand/convert these characters."
                }
                return $true
            })]
        [string]$ToFirstName,
        [parameter(ValueFromPipelineByPropertyName, Position = 8, Mandatory = $false)]
        [ValidateScript( {
                # Exclude german umlauts and other latin/non-latin diacritics or invalid characters that the api does not understand.
                $InvalidChars = 'ßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ'
                $regex = [Regex]::Escape($InvalidChars)
                $regex = "[$regex]"
                $Invalid = [Regex]::Matches($_, $regex, 'IgnoreCase') | Select-Object -ExpandProperty Value | Sort-Object -Unique
                if ($null -ne $Invalid) {
                    throw "ERROR: The specified Subject contains the following illegal characters: '$Invalid'. Please do not use the characters '$InvalidChars' for the Subject since the api does not understand/convert these characters."
                }
                return $true
            })]
        [string]$EmailSubject,
        [parameter(ValueFromPipelineByPropertyName, Position = 9, Mandatory = $false)]
        [string]$EmailBody,
        [parameter(ValueFromPipelineByPropertyName, Position = 10, Mandatory = $false)]
        [ValidateScript( {
                # Exclude german umlauts and other latin/non-latin diacritics or invalid characters that the api does not understand.
                $InvalidChars = 'ßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ'
                $regex = [Regex]::Escape($InvalidChars)
                $regex = "[$regex]"
                $Invalid = [Regex]::Matches($_, $regex, 'IgnoreCase') | Select-Object -ExpandProperty Value | Sort-Object -Unique
                if ($null -ne $Invalid) {
                    throw "ERROR: The specified Passphrase contains the following illegal characters: '$Invalid'. Please do not use the characters '$InvalidChars' for the Passphrase since the api does not understand these characters."
                }
                return $true
            })]
        [string]$Passphrase,
        [parameter(ValueFromPipelineByPropertyName, Position = 11, Mandatory = $false)]
        [string]$Reason
    )

    begin {
        # Import PasswordState Environment for validation of PasswordsInPlainText setting
        $PWSProfile = Get-PasswordStateEnvironment
        # Add a reason to the audit log if specified
        If ($Reason) {
            $headerreason = @{"Reason" = "$Reason" }
            $parms = @{ExtraParams = @{"Headers" = $headerreason } }
        }
        else { $parms = @{ } }
    }
    process {
        # Build the Custom object to convert to json and send to the api.
        # Remove Diacritics and other from the api not understandable characters from the variables that can contain HTML
        $body = [PSCustomObject]@{
            "PasswordID"           = $PasswordID
            "PrefixMessageContent" = $PrefixMessageContent | Remove-DiacriticsFromString
            "AppendMessageContent" = $AppendMessageContent | Remove-DiacriticsFromString
            "ExpiresAt"            = $ExpiresAt
            "NoViews"              = $NoViews
            "ToEmailAddress"       = $ToEmailAddress
            "ToFirstName"          = $ToFirstName
            "EmailSubject"         = $EmailSubject
            "EmailBody"            = $EmailBody | Remove-DiacriticsFromString
            "Message"              = $message | Remove-DiacriticsFromString
            "Reason"               = $Reason
            "Passphrase"           = $Passphrase
        }
        # Adding API Key to the body if using APIKey as Authentication Type to use the api instead of winAPI
        if ($PWSProfile.AuthType -eq "APIKey") {
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $PWSProfile.Apikey
        }
        if ($PSCmdlet.ShouldProcess("Sending self destruct message to '$ToEmailAddress' for PasswordID '$PasswordID' and/or Message '$Message' which expires at '$ExpiresAt' and can be viewed '$NoViews' times")) {
            # Sort the CustomObject and then covert body to json and execute the api query
            if ($body) {
                $body = "$($body |ConvertTo-Json)"
                try {
                    $output = New-PasswordStateResource -uri "/winapi/selfdestruct" -body $body @parms -ErrorAction Stop
                }
                catch {
                    throw $_.Exception
                }
            }
        }
    }

    end {
        if ($output) {
            return $output
        }
    }
}