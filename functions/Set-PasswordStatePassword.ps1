function Set-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'API requires password be passed as plain text')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'API requires password be passed as plain text')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Needed for backward compatability')]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, Position = 0)][Nullable[System.Int32]]$PasswordID,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 1)][ValidateLength(1, 255)][string]$Title,
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
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "Password", Position = 1)]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = "GeneratePassword", Position = 1)]
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
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "HeartbeatSchedule", Position = 0)]
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
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, ParameterSetName = "Heartbeat", Position = 2)]
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
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false, Position = 26)][string]$Reason
    )

    begin {
        # Import PasswordState Environment for validation of PasswordsInPlainText setting
        $PWSProfile = Get-PasswordStateEnvironment
        # Add a reason to the audit log if specified
        If ($Reason) {
            $headerreason = @{"Reason" = "$reason" }
            $parms = @{ExtraParams = @{"Headers" = $headerreason } }
        }
        else { $parms = @{ } }
    }

    process {
        if ($PasswordID) {
            try {
                $result = Get-PasswordStatePassword -PasswordID $PasswordID -ErrorAction Stop
            }
            catch {
                throw "Given PasswordID '$PasswordID' not found"
            }
            Write-PSFMessage -Level Verbose -Message "Password with PasswordID '$PasswordID' found. Updating password '$($result.title)'..."
        }
        else {
            throw "Please apply '-PasswordID'! PasswordID is needed to update passwords."
        }
        if ($PSCmdlet.ShouldProcess("PasswordID:$($result.PasswordID) Title:$($result.Title)")) {
            # Loop through each of the bound parameters and set the updated value on the object.
            foreach ($i in $PSBoundParameters.Keys) {
                # Replace Result property with that of the bound parameter
                $NotProcess = "PreventAuditing", "Reason", "verbose", "erroraction", "debug", "whatif", "confirm"
                if ($NotProcess -notcontains $i) {
                    if ($i -eq "Password" -and $PSBoundParameters.$($i) -eq "EncryptedPassword") {
                        $result.DecryptPassword()
                    }
                    else {
                        # if existing result object does contain a specified property replace it with the specified property value
                        if (Get-Member -InputObject $result -MemberType Property -Name $i) {
                            $result.$($i) = $PSBoundParameters.$($i)
                        }
                        # if existing result object does NOT contain a specified property, create a new member and add the new value
                        else {
                            # if specified property type is a switch parameter, we need to specified the value of sub property IsPresent
                            if ($PSBoundParameters.$($i).GetType().Name -eq "SwitchParameter") {
                                try {
                                    $result | Add-Member -MemberType NoteProperty -Name $i -Value $PSBoundParameters.$($i).IsPresent -ErrorAction Stop
                                }
                                catch {
                                    throw $_.Exception
                                }
                            }
                            else {
                                try {
                                    $result | Add-Member -MemberType NoteProperty -Name $i -Value $PSBoundParameters.$($i) -ErrorAction Stop
                                }
                                catch {
                                    throw $_.Exception
                                }
                            }
                        }
                    }
                }
            }
            # Store in a new variable and remove all null values as password state doesn't like nulls.
            $body = $result
            # Initialize array for the select statement later
            $selections = @()
            # Get all properties from the object.
            $properties = ($body | Get-Member -Force | Where-Object { $_.MemberType -eq "Property" -or $_.MemberType -eq "NoteProperty" }).Name
            # Get only those properties which aren't empty and add them to our selection array.
            foreach ($item in $properties) {
                if ($body.$($item) -notlike $null) {
                    $selections += $item
                }
            }
            # Update body variable to contain only the properties with data.
            $body = $body | Select-Object $selections
            # Write back to password state.
            $uri = "/api/passwords"
            $body = "$($body | ConvertTo-Json)"
            try {
                $output = Set-PasswordStateResource -uri $uri -body $body @parms -ErrorAction Stop
            }
            catch {
                throw $_.Exception
            }
            if ($output) {
                if ((Get-Member -InputObject $output -MemberType NoteProperty -Name Status) -and (Get-Member -InputObject $output -MemberType NoteProperty -Name CurrentPassword) -and (Get-Member -InputObject $output -MemberType NoteProperty -Name NewPassword)) {
                    try {
                        [PasswordResetResult]$output = $output
                    }
                    catch {
                        throw $_.Exception
                    }
                    if (!$PWSProfile.PasswordsInPlainText) {
                        $output.CurrentPassword = [EncryptedPassword]$output.CurrentPassword
                        $output.NewPassword = [EncryptedPassword]$output.NewPassword
                    }
                    return
                }
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

    end {
        if ($output) {
            return $output
        }
    }
}

Set-Alias -Name Update-PasswordStatePassword -Value Set-PasswordStatePassword -Force