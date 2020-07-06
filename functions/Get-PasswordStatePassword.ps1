Function Get-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'No Password is used only ID.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'PasswordID is not a password')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Needed for backward compatability')]
    [CmdletBinding(DefaultParameterSetName = 'General')]
    Param
    (
        [Parameter(ParameterSetName = 'General', ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0, Mandatory = $false)][string]$Search,
        [Parameter(ParameterSetName = 'PasswordID', ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)][ValidateNotNullOrEmpty()][int32]$PasswordID,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 0)][ValidateLength(1, 255)][string]$Title,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 1)][ValidateLength(1, 255)][string]$UserName,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 2)][ValidateLength(1, 200)][string]$HostName,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 3)][ValidateLength(1, 50)][string]$Domain,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 4)][string]$AccountType,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 5)][ValidateLength(1, 255)][string]$Description,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 6)][string]$Notes,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 7)][ValidateLength(1, 255)][string]$URL,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 8)][string]$SiteID,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 9)][string]$SiteLocation,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 10)][string]$GenericField1,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 11)][string]$GenericField2,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 12)][string]$GenericField3,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 13)][string]$GenericField4,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 14)][string]$GenericField5,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 15)][string]$GenericField6,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 16)][string]$GenericField7,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 17)][string]$GenericField8,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 18)][string]$GenericField9,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 19)][string]$GenericField10,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 20)][string]$AccountTypeID,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 21)][switch]$PasswordResetEnabled,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 22)]
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
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 23, HelpMessage = 'Format: ExpiryDate>=2012-07-14,ExpiryDate<=2020-12-31')]
        [ValidateScript( {
                # The dates here for the ExpiryDate(s) do NOT need to be culture aware, so we can validate a specific date format with a regular expression.
                # So we only need to validate if the format of the entire ExpiryDateRange string is correct.
                if ($_ -notmatch '(ExpiryDate(<|>|=|<=|>=)((19|20)[0-9]{2}[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01]))),(ExpiryDate(<|>|=|<=|>=)((19|20)[0-9]{2}[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])))|(?<!,)ExpiryDate(<|>|=|<=|>=)((19|20)[0-9]{2}[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01]))') {
                    throw "Given ExpiryDateRange '$_' is not a valid ExpiryDateRange format. Please use the following format (single comma between ExpiryDates): 'ExpiryDate>=2012-07-14,ExpiryDate<=2020-12-31' (Also, please specify the ExpiryDates in the ISO 8601 international date format 'YYYY-MM-DD')."
                }
                else {
                    $true
                }
            })]
        [string]$ExpiryDateRange,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 24)][ValidateSet('AND', 'OR')][string]$AndOr,
        [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 1)][Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 25)][Nullable[System.Int32]]$PasswordListID,
        [parameter(ValueFromPipelineByPropertyName, Position = 26)][string]$Reason,
        [parameter(ValueFromPipelineByPropertyName, Position = 27)][switch]$PreventAuditing,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 28)][ValidateLength(1, 50)][string]$ADDomainNetBIOS
    )

    Begin {
        # Import PasswordState Environment for validation of PasswordsInPlainText setting
        $PWSProfile = Get-PasswordStateEnvironment
        # Add a reason to the audit log if specified
        If ($Reason) {
            $headerreason = @{"Reason" = "$Reason" }
            $parms = @{ExtraParams = @{"Headers" = $headerreason } }
        }
        else { $parms = @{ } }
    }

    Process {
        # If PasswordListID wasn't set, set variable to $null
        If (!($PSBoundParameters.ContainsKey('PasswordListID'))) {
            $PasswordListID = $null
        }

        Switch ($PSCmdlet.ParameterSetName) {
            # General search
            'General' {
                if ([string]::IsNullOrEmpty($Search)) {
                    # Return all Passwords for the given PasswordList
                    if ($PasswordListID) {
                        $uri = "/api/passwords/$($PasswordListID)?QueryAll"
                    }
                    # Return all Passwords that the user/APIKey has access to
                    else {
                        $uri = "/api/passwords/?QueryAll"
                    }
                }
                Else {
                    $uri = "/api/searchpasswords/$($PasswordListID)?Search=$([System.Web.HttpUtility]::UrlEncode($Search))"
                }
            }
            # Search on a specific password ID
            'PasswordID' {
                If ($PSBoundParameters.ContainsKey('PasswordID')) {
                    # if only PasswordID is specified, so searching for a specific ID, PreventAuditing is not possible
                    $PreventAuditing = $false
                }
                $uri = "/api/passwords/$($PasswordID)"
            }
            # Search with a variety of filters
            'Specific' {
                $BuildURL = '?'
                If ($Title) { $BuildURL += "Title=$([System.Web.HttpUtility]::UrlEncode($Title))&" }
                If ($UserName) { $BuildURL += "UserName=$([System.Web.HttpUtility]::UrlEncode($UserName))&" }
                If ($HostName) { $BuildURL += "HostName=$([System.Web.HttpUtility]::UrlEncode($HostName))&" }
                If ($ADDomainNetBIOS) { $BuildURL += "ADDomainNetBIOS=$([System.Web.HttpUtility]::UrlEncode($ADDomainNetBIOS))&" }
                If ($Domain) { $BuildURL += "Domain=$([System.Web.HttpUtility]::UrlEncode($Domain))&" }
                If ($AccountType) { $BuildURL += "AccountType=$([System.Web.HttpUtility]::UrlEncode($AccountType))&" }
                If ($Description) { $BuildURL += "Description=$([System.Web.HttpUtility]::UrlEncode($Description))&" }
                If ($Notes) { $BuildURL += "Notes=$([System.Web.HttpUtility]::UrlEncode($Notes))&" }
                If ($URL) { $BuildURL += "URL=$([System.Web.HttpUtility]::UrlEncode($URL))&" }
                If ($SiteID) { $BuildURL += "SiteID=$([System.Web.HttpUtility]::UrlEncode($SiteID))&" }
                If ($SiteLocation) { $BuildURL += "SiteLocation=$([System.Web.HttpUtility]::UrlEncode($SiteLocation))&" }
                If ($GenericField1) { $BuildURL += "GenericField1=$([System.Web.HttpUtility]::UrlEncode($GenericField1))&" }
                If ($GenericField2) { $BuildURL += "GenericField2=$([System.Web.HttpUtility]::UrlEncode($GenericField2))&" }
                If ($GenericField3) { $BuildURL += "GenericField3=$([System.Web.HttpUtility]::UrlEncode($GenericField3))&" }
                If ($GenericField4) { $BuildURL += "GenericField4=$([System.Web.HttpUtility]::UrlEncode($GenericField4))&" }
                If ($GenericField5) { $BuildURL += "GenericField5=$([System.Web.HttpUtility]::UrlEncode($GenericField5))&" }
                If ($GenericField6) { $BuildURL += "GenericField6=$([System.Web.HttpUtility]::UrlEncode($GenericField6))&" }
                If ($GenericField7) { $BuildURL += "GenericField7=$([System.Web.HttpUtility]::UrlEncode($GenericField7))&" }
                If ($GenericField8) { $BuildURL += "GenericField8=$([System.Web.HttpUtility]::UrlEncode($GenericField8))&" }
                If ($GenericField9) { $BuildURL += "GenericField9=$([System.Web.HttpUtility]::UrlEncode($GenericField9))&" }
                If ($GenericField10) { $BuildURL += "GenericField10=$([System.Web.HttpUtility]::UrlEncode($GenericField10))&" }
                If ($AccountTypeID) { $BuildURL += "AccountTypeID=$([System.Web.HttpUtility]::UrlEncode($AccountTypeID))&" }
                If ($PasswordResetEnabled.IsPresent) { $BuildURL += "PasswordResetEnabled=$([System.Web.HttpUtility]::UrlEncode('true'))&" }
                If ($ExpiryDateRange) { $BuildURL += "ExpiryDateRange=$([System.Web.HttpUtility]::UrlEncode($ExpiryDateRange))&" }
                If ($ExpiryDate) { $BuildURL += "ExpiryDate=$([System.Web.HttpUtility]::UrlEncode($ExpiryDate))&" }
                If ($AndOr) { $BuildURL += "AndOr=$([System.Web.HttpUtility]::UrlEncode($AndOr))&" }

                $BuildURL = $BuildURL -Replace ".$"

                if ($PasswordListID) {
                    $uri = "/api/searchpasswords/$($PasswordListID)$($BuildURL)"
                }
                else {
                    $uri = "/api/searchpasswords/$($BuildURL)"
                }
            }
        }
        Switch ($PreventAuditing) {
            $True {
                $uri += "&PreventAuditing=true"
            }
            Default {

            }
        }
        Try {
            $output = Get-PasswordStateResource -uri $uri @parms -ErrorAction Stop
        }
        Catch {
            Throw $_.Exception
        }
        if ($output) {
            # if more than one password object was found, we need to cast each password object to [PasswordResult] method
            foreach ($PWSEntry in $output) {
                try {
                    [PasswordResult]$PWSEntry = $PWSEntry
                }
                catch {
                    throw $_.Exception
                }
                if (!$PWSProfile.PasswordsInPlainText) {
                    $PWSEntry.Password = [EncryptedPassword]$PWSEntry.Password
                }
                $PWSEntry
            }
        }
    }
    end {
    }
}

Set-Alias -Name Find-PasswordStatePassword -Value Get-PasswordStatePassword -Force