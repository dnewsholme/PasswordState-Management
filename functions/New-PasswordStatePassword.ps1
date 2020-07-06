function New-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Password can only be passed to api in plaintext due to PasswordState api'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'Credential would break cmdlet flow')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Needed for backward compatability')]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, Position = 0)][Nullable[System.Int32]]$PasswordListID,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, Position = 1)][ValidateLength(1, 255)][string]$Title,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 2)][ValidateLength(1, 255)][string]$Username,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "Password", Position = 0)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "ResetSchedule", Position = 9)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 9)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Heartbeat", Position = 9)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "HeartbeatSchedule", Position = 9)]
        [ValidateScript( {
                # Exclude german umlauts and other latin/non-latin diacritics or invalid characters that the api does not understand.
                $InvalidChars = 'ßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ'
                $regex = [Regex]::Escape($InvalidChars)
                $regex = "[$regex]"
                $Invalid = [Regex]::Matches($_, $regex, 'IgnoreCase') | Select-Object -ExpandProperty Value | Sort-Object -Unique
                if ($null -ne $Invalid) {
                    throw "ERROR: The specified password contains the following illegal characters: '$Invalid'. Please do not use the characters '$InvalidChars' in your password since the api does not understand these characters."
                }
                return $true
            })]
        [string]$Password,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 4)][ValidateLength(1, 255)][string]$Description,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "GeneratePassword", Position = 0)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "ResetSchedule", Position = 10)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 10)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Heartbeat", Position = 10)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "HeartbeatSchedule", Position = 10)]
        [switch]$GeneratePassword,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 6)][string]$Notes,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 7)][ValidateLength(1, 255)][string]$Url,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 8)][ValidateLength(1, 50)][string]$AccountType,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 9)][AllowNull()][Nullable[System.Int32]]$AccountTypeID = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 10)][string]$GenericField1 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 11)][string]$GenericField2 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 12)][string]$GenericField3 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 13)][string]$GenericField4 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 14)][string]$GenericField5 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 15)][string]$GenericField6 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 16)][string]$GenericField7 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 17)][string]$GenericField8 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 18)][string]$GenericField9 = $null,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 19)][string]$GenericField10 = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 20)][switch]$GenerateGenFieldPassword,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "Reset", Position = 0)]
        [switch]$PasswordResetEnabled,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "ResetSchedule", Position = 1)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 1)]
        [switch]$EnablePasswordResetSchedule,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "ResetSchedule", Position = 2)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 2)]
        [ValidateScript( {
                if ($_ -notmatch '^(([0-1][0-9]|[2-2][0-3]):([0-5][0-9]))$') {
                    throw "Given PasswordResetSchedule '$_' is not a valid Schedule! Please specify a correct schedule in (Date)Time Format, e.g. '23:10', '00:15', '09:00' from 00:00-23:59."
                }
                else {
                    $true
                }
            })]
        [string]$PasswordResetSchedule,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 21)][Nullable[System.Int32]]$AddDaysToExpiryDate = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 22)][Nullable[System.Int32]]$ScriptID = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 23)][Nullable[System.Int32]]$PrivilegedAccountID = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "Heartbeat", Position = 0)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 3)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "ResetSchedule", Position = 3)]
        [switch]$HeartbeatEnabled,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "HeartbeatSchedule", Position = 0)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Heartbeat", Position = 1)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 5)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "ResetSchedule", Position = 5)]
        [ValidateScript( {
                if ($_ -notmatch '^(([0-1][0-9]|[2-2][0-3]):([0-5][0-9]))$') {
                    throw "Given HeartbeatSchedule '$_' is not a valid Schedule! Please specify a correct schedule in (Date)Time Format, e.g. '23:10', '00:15', '09:00' from 00:00-23:59."
                }
                else {
                    $true
                }
            })]
        [string]$HeartbeatSchedule,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "Heartbeat", Position = 2)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 5)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "ResetSchedule", Position = 5)]
        [Nullable[System.Int32]]$ValidationScriptID = $null,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 6)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "ResetSchedule", Position = 6)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Heartbeat", Position = 3)]
        [ValidateLength(1, 200)]
        [string]$HostName,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 7)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "ResetSchedule", Position = 7)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Heartbeat", Position = 4)]
        [ValidateLength(1, 50)]
        [string]$ADDomainNetBIOS,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Heartbeat", Position = 5)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Reset", Position = 8)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "ResetSchedule", Position = 8)]
        [switch]$ValidateWithPrivAccount,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 24)]
        [ValidateScript( {
                # The dates for the ExpiryDate needs to be culture aware, so we cannot validate a specific date format.
                function isDate([string]$StrDate) {
                    [boolean]($StrDate -as [DateTime])
                }
                if (!(isDate $_)) {
                    throw "Given ExpiryDate '$_' is not a valid Date format. Also, please specify the ExpiryDate in the date format that you have chosen in 'System Settings - miscellaneous - Default Locale' (Default: 'YYYY-MM-DD')."
                }
                else {
                    $true
                }
            })]
        [string]$ExpiryDate,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 25)][switch]$AllowExport,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 25)][ValidateLength(1, 200)][string]$WebUser_ID,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 25)][ValidateLength(1, 200)][string]$WebPassword_ID,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 26)][switch]$SkipExistenceCheck,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 27)][string]$Reason
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
        # if -SkipExistenceCheck is applied, no check if the requested password entry exists is executed
        if (!($PSBoundParameters.ContainsKey('SkipExistenceCheck')) -and ($PSBoundParameters.ContainsKey('UserName'))) {
            # Check to see if the requested password entry exists before continuing.
            try {
                $result = Get-PasswordStatePassword -Title $Title -UserName $Username -ErrorAction Stop
            }
            Catch {
                Write-PSFMessage -Level Verbose -Message "No existing password...Continuing."
            }
            if ($result.Username -eq $Username -and $result.title -eq $title) {
                throw "Found existing Password Entry with same title '$title' and same username '$Username' in PasswordList '$($result.PasswordList)' ('$($result.PasswordListID)')! (Use -SkipExistenceCheck to skip this check)."
            }
        }
    }

    process {
        # Build the Custom object to convert to json and send to the api.
        if ($continue -ne $false) {
            $body = [PSCustomObject]@{
                "PasswordListID"              = $PasswordListID
                "Username"                    = $Username
                "Description"                 = $Description
                "Title"                       = $Title
                "Notes"                       = $Notes
                "URL"                         = $Url
                "AccountTypeID"               = $AccountTypeID
                "AddDaysToExpiryDate"         = $AddDaysToExpiryDate
                "ScriptID"                    = $ScriptID
                "PrivilegedAccountID"         = $PrivilegedAccountID
                "PasswordResetEnabled"        = $PasswordResetEnabled.IsPresent
                "EnablePasswordResetSchedule" = $EnablePasswordResetSchedule.IsPresent
                "HeartbeatEnabled"            = $HeartbeatEnabled.IsPresent
                "ValidationScriptID"          = $ValidationScriptID
                "GeneratePassword"            = $GeneratePassword.IsPresent
                "GenerateGenFieldPassword"    = $GenerateGenFieldPassword.IsPresent
                "ValidateWithPrivAccount"     = $ValidateWithPrivAccount.IsPresent
                "AllowExport"                 = $AllowExport.IsPresent
            }

            try {
                $GenericFields = Get-Variable GenericField* | Where-Object { $_.Value -ne [NullString] -and $null -ne $_.Value }
            }
            Catch {
                Write-PSFMessage -Level Verbose -Message "No GenericFields specified"
            }
            if ($GenericFields) {
                $GenericFields | ForEach-Object {
                    $body | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Value
                }
            }
            if ($Password) {
                $body | Add-Member -NotePropertyName "Password" -NotePropertyValue $Password
            }
            if ($Hostname) {
                $body | Add-Member -NotePropertyName "Hostname" -NotePropertyValue $Hostname
            }
            if ($ADDomainNetBIOS) {
                $body | Add-Member -NotePropertyName "ADDomainNetBIOS" -NotePropertyValue $ADDomainNetBIOS
            }
            if ($HeartbeatSchedule) {
                $body | Add-Member -NotePropertyName "HeartbeatSchedule" -NotePropertyValue $HeartbeatSchedule
            }
            if ($PasswordResetSchedule) {
                $body | Add-Member -NotePropertyName "PasswordResetSchedule" -NotePropertyValue $PasswordResetSchedule
            }
            if ($AccountType) {
                $body | Add-Member -NotePropertyName "AccountType" -NotePropertyValue $AccountType
            }
            if ($ExpiryDate) {
                $body | Add-Member -NotePropertyName "ExpiryDate" -NotePropertyValue $ExpiryDate
            }
            if ($WebUser_ID) {
                $body | Add-Member -NotePropertyName "WebUser_ID" -NotePropertyValue $WebUser_ID
            }
            if ($WebPassword_ID) {
                $body | Add-Member -NotePropertyName "WebPassword_ID" -NotePropertyValue $WebPassword_ID
            }
            if ($PSCmdlet.ShouldProcess("PasswordList:$passwordListID Title:$title Username:$username")) {
                $uri = "/api/passwords"
                $body = "$($body |ConvertTo-Json)"
                if ($body) {
                    try {
                        $output = New-PasswordStateResource -uri $uri -body $body @parms -ErrorAction Stop
                    }
                    catch {
                        throw $_.Exception
                    }
                    if ($output) {
                        try {
                            [PasswordResult]$output = $output
                        }
                        catch {
                            throw $_.Exception
                        }
                        if (!$PWSProfile.PasswordsInPlainText) {
                            $output.Password = [EncryptedPassword]$output.Password
                        }
                    }
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