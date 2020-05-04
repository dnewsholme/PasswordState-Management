Function Get-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'No Password is used only ID.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'PasswordID isnt a password')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Needed for backward compatability')]
    [CmdletBinding(DefaultParameterSetName = 'General')]
    Param
    (
        [Parameter(ParameterSetName = 'General', ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0, Mandatory = $false)][string]$Search,
        [Parameter(ParameterSetName = 'PasswordID', ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)][ValidateNotNullOrEmpty()][int32]$PasswordID,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 0)][string]$Title,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 1)][string]$UserName,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 2)][string]$HostName,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 3)][string]$Domain,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 4)][string]$AccountType,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 5)][string]$Description,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 6)][string]$Notes,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 7)][string]$URL,
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
        [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 1)][Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 20)][int32]$PasswordListID,
        [parameter(ValueFromPipelineByPropertyName, Position = 21)][string]$Reason,
        [parameter(ValueFromPipelineByPropertyName, Position = 22)][switch]$PreventAuditing
    )

    Begin {
        $PWSProfile = Get-PasswordStateEnvironment -path $Script:Preferences.Path
    }

    Process {
        # Add a reason to the audit log
        If ($Reason) {
            $headerreason = @{"Reason" = "$reason"}
            $parms = @{ExtraParams = @{"Headers" = $headerreason}}
        }

        # If PasswordListID wasn't set, make the variable an empty string
        If (!($PSBoundParameters.ContainsKey('PasswordListID'))) {
            [string]$PasswordListID = ''
        }

        Switch ($PSCmdlet.ParameterSetName) {
            # General search
            'General' {
                if ([string]::IsNullOrEmpty($Search)) {
                    # Return all Passwords
                    $uri = "/api/passwords/$($PasswordlistID)?QueryAll"
                }
                Else {
                    $uri = "/api/searchpasswords/$($PasswordListID)?Search=$([System.Web.HttpUtility]::UrlEncode($Search))"
                }
            }
            # Search on a specific password ID
            'PasswordID' {
                $uri = "/api/passwords/$($PasswordID)"
            }
            # Search with a variety of filters
            'Specific' {
                $BuildURL = '?'
                If ($Title) {          $BuildURL += "Title=$([System.Web.HttpUtility]::UrlEncode($Title))&" }
                If ($UserName) {       $BuildURL += "UserName=$([System.Web.HttpUtility]::UrlEncode($UserName))&" }
                If ($HostName) {       $BuildURL += "HostName=$([System.Web.HttpUtility]::UrlEncode($HostName))&" }
                If ($Domain) {         $BuildURL += "Domain=$([System.Web.HttpUtility]::UrlEncode($Domain))&" }
                If ($AccountType) {    $BuildURL += "AccountType=$([System.Web.HttpUtility]::UrlEncode($AccountType))&" }
                If ($Description) {    $BuildURL += "Description=$([System.Web.HttpUtility]::UrlEncode($Description))&" }
                If ($Notes) {          $BuildURL += "Notes=$([System.Web.HttpUtility]::UrlEncode($Notes))&" }
                If ($URL) {            $BuildURL += "URL=$([System.Web.HttpUtility]::UrlEncode($URL))&" }
                If ($SiteID) {         $BuildURL += "SiteID=$([System.Web.HttpUtility]::UrlEncode($SiteID))&" }
                If ($SiteLocation) {   $BuildURL += "SiteLocation=$([System.Web.HttpUtility]::UrlEncode($SiteLocation))&" }
                If ($GenericField1) {  $BuildURL += "GenericField1=$([System.Web.HttpUtility]::UrlEncode($GenericField1))&" }
                If ($GenericField2) {  $BuildURL += "GenericField2=$([System.Web.HttpUtility]::UrlEncode($GenericField2))&" }
                If ($GenericField3) {  $BuildURL += "GenericField3=$([System.Web.HttpUtility]::UrlEncode($GenericField3))&" }
                If ($GenericField4) {  $BuildURL += "GenericField4=$([System.Web.HttpUtility]::UrlEncode($GenericField4))&" }
                If ($GenericField5) {  $BuildURL += "GenericField5=$([System.Web.HttpUtility]::UrlEncode($GenericField5))&" }
                If ($GenericField6) {  $BuildURL += "GenericField6=$([System.Web.HttpUtility]::UrlEncode($GenericField6))&" }
                If ($GenericField7) {  $BuildURL += "GenericField7=$([System.Web.HttpUtility]::UrlEncode($GenericField7))&" }
                If ($GenericField8) {  $BuildURL += "GenericField8=$([System.Web.HttpUtility]::UrlEncode($GenericField8))&" }
                If ($GenericField9) {  $BuildURL += "GenericField9=$([System.Web.HttpUtility]::UrlEncode($GenericField9))&" }
                If ($GenericField10) { $BuildURL += "GenericField10=$([System.Web.HttpUtility]::UrlEncode($GenericField10))&" }

                $BuildURL = $BuildURL -Replace ".$"

                $uri = "/api/searchpasswords/$($PasswordListID)$($BuildURL)"
            }
        }
        Switch ($PreventAuditing){
            $True {
              $uri +=  "&PreventAuditing=true"
            }
            Default{

            }
        }
        Try {
            foreach ($PWSEntry in (Get-PasswordStateResource -URI $uri @parms  -Method GET)) {
                [PasswordResult]$PWSEntry = $PWSEntry
                if(!$PWSProfile.PasswordsInPlainText) {
                    $PWSEntry.Password = [EncryptedPassword]$PWSEntry.Password
                }
                $PWSEntry
            }
        }
        Catch {
            Throw $_.Exception
        }

    }
}

Set-Alias -Name Find-PasswordstatePassword -Value Get-PasswordStatePassword -Force