function New-PasswordStateList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password field.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = '*UserID and *PasswordID are not a user and not a password')]
    [cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)]
        [string]$Name,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $true)]
        [string]$Description,
        [parameter(ValueFromPipelineByPropertyName, Position = 2, Mandatory = $false, HelpMessage = "FolderID 0 = Folder will be created in the root of the Navigation Tree")]
        [Alias("NestUnderFolderID")]
        [int32]$FolderID = 0,
        [parameter(parameterSetName = 'Private', ValueFromPipelineByPropertyName, Position = 3, Mandatory = $false)]
        [parameter(parameterSetName = 'ListSettings', ValueFromPipelineByPropertyName, Position = 3, Mandatory = $true)]
        [parameter(parameterSetName = 'Permission', ValueFromPipelineByPropertyName, Position = 3, Mandatory = $false)]
        [string]$CopySettingsFromPasswordListID = $null,
        [parameter(parameterSetName = 'Permission', ValueFromPipelineByPropertyName, Position = 4, Mandatory = $false)]
        [string]$CopyPermissionsFromPasswordListID = $null,
        [parameter(parameterSetName = 'Template', ValueFromPipelineByPropertyName, Position = 3, Mandatory = $false)]
        [parameter(parameterSetName = 'TemplateSettings', ValueFromPipelineByPropertyName, Position = 4, Mandatory = $true)]
        [parameter(parameterSetName = 'Permission', ValueFromPipelineByPropertyName, Position = 5, Mandatory = $false)]
        [string]$CopySettingsFromTemplateID = $null,
        [parameter(parameterSetName = 'Permission', ValueFromPipelineByPropertyName, Position = 6, Mandatory = $false)]
        [string]$CopyPermissionsFromTemplateID = $null,
        [parameter(parameterSetName = 'Permission', ValueFromPipelineByPropertyName, Position = 6, Mandatory = $false)]
        [parameter(parameterSetName = 'Template', ValueFromPipelineByPropertyName, Position = 4, Mandatory = $true)]
        [string]$LinkToTemplate = $null,
        [parameter(parameterSetName = 'Template', ValueFromPipelineByPropertyName, Position = 5, Mandatory = $false)]
        [parameter(parameterSetName = 'Private', ValueFromPipelineByPropertyName, Position = 4, Mandatory = $true)]
        [switch]$PrivatePasswordList,
        [parameter(parameterSetName = 'Permission', Position = 9, ValueFromPipelineByPropertyName, Mandatory = $false)]
        [parameter(parameterSetName = 'Private', ValueFromPipelineByPropertyName, Position = 5, Mandatory = $false)]
        [string]$ApplyPermissionsForUserID = $null,
        [parameter(parameterSetName = 'Permission', Position = 10, ValueFromPipelineByPropertyName, Mandatory = $false)]
        [string]$ApplyPermissionsForSecurityGroupID = $null,
        [parameter(parameterSetName = 'Permission', Position = 11, ValueFromPipelineByPropertyName, Mandatory = $false)]
        [string]$ApplyPermissionsForSecurityGroupName = $null,
        [parameter(parameterSetName = 'Private', ValueFromPipelineByPropertyName, Position = 6, Mandatory = $false)]
        [parameter(ParameterSetName = 'Permission', Position = 12, ValueFromPipelineByPropertyName, Mandatory = $true)]
        [ValidateSet('A', 'M', 'V')]
        [string]$Permission,
        [parameter(ValueFromPipelineByPropertyName, Position = 13, Mandatory = $false)]
        [ValidateLength(0, 50)]
        [Alias("Image")]
        [string]$ImageFileName,
        [parameter(ValueFromPipelineByPropertyName, Position = 14, Mandatory = $false, HelpMessage = "SiteID 0 = Default site 'Internal'")]
        [int32]$SiteID = 0,
        [parameter(ValueFromPipelineByPropertyName, Position = 15, Mandatory = $false)]
        [switch]$AllowExport,
        [parameter(ValueFromPipelineByPropertyName, Position = 16, Mandatory = $false)]
        [string]$Guide,
        [parameter(ValueFromPipelineByPropertyName, Position = 17, Mandatory = $false)]
        [switch]$PreventBadPasswordUse,
        [parameter(ValueFromPipelineByPropertyName, Position = 18, Mandatory = $false)]
        [switch]$PasswordResetEnabled,
        [parameter(ValueFromPipelineByPropertyName, Position = 19, Mandatory = $false, HelpMessage = "PasswordGeneratorID 0 = 'Using user's personal Password Generator Options'")]
        [int32]$PasswordGeneratorID = 0,
        [parameter(ValueFromPipelineByPropertyName, Position = 19, Mandatory = $false, HelpMessage = "PasswordStrengthPolicyID 1 = 'Default Password Strength Policy'")]
        [int32]$PasswordStrengthPolicyID = 1,
        [parameter(ValueFromPipelineByPropertyName, Position = 20, Mandatory = $false)]
        [switch]$Sort
    )

    begin {
        If (($PSBoundParameters.ContainsKey('AllowExport')) -or ($PSBoundParameters.ContainsKey('PreventBadPasswordUse')) -or ($PSBoundParameters.ContainsKey('PasswordResetEnabled')) -or ($PSBoundParameters.ContainsKey('PasswordGeneratorID')) -or ($PSBoundParameters.ContainsKey('PasswordStrengthPolicyID'))) {
            throw "The following properties are not implemented yet to the PasswordState (Win)API, please remove these parameters: 'AllowExport', 'PreventBadPasswordUse', 'PasswordResetEnabled', 'PasswordGeneratorID', 'PasswordStrengthPolicyID'. `
            If you would like to change these properties, please copy the settings from an existing password list (-CopySettingsFromPasswordListID) or create a password list template and copy the settings from the template (-CopySettingsFromTemplateID)"
        }
    }
    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [PSCustomObject]@{
            "PasswordList"                         = $Name
            "Description"                          = $Description
            "CopySettingsFromPasswordListID"       = $CopySettingsFromPasswordListID
            "CopySettingsFromTemplateID"           = $CopySettingsFromTemplateID
            "CopyPermissionsFromPasswordListID"    = $CopyPermissionsFromPasswordListID
            "CopyPermissionsFromTemplateID"        = $CopyPermissionsFromTemplateID
            "NestUnderFolderID"                    = $FolderID
            "LinkToTemplate"                       = $LinkToTemplate
            "SiteID"                               = $SiteID
            "ApplyPermissionsForUserID"            = $ApplyPermissionsForUserID
            "ApplyPermissionsForSecurityGroupID"   = $ApplyPermissionsForSecurityGroupID
            "ApplyPermissionsForSecurityGroupName" = $ApplyPermissionsForSecurityGroupName
            "ImageFileName"                        = $ImageFileName
            "PasswordGeneratorID"                  = $PasswordGeneratorID
            "PasswordStrengthPolicyID"             = $PasswordStrengthPolicyID
            "PreventBadPasswordUse"                = $PreventBadPasswordUse.IsPresent
            "AllowExport"                          = $AllowExport.IsPresent
            "PasswordResetEnabled"                 = $PasswordResetEnabled.IsPresent
            "PrivatePasswordList"                  = $PrivatePasswordList.IsPresent
        }
        # When apply permissions to the newly created Password List (for a User or Security Group), you must specify the values of A, M or V - Administrator, Modify or View rights.
        if ($Permission) {
            $body | Add-Member -NotePropertyName "Permission" -NotePropertyValue $Permission
        }
        # Any associated instructions (guide) for how the password list should be used (Can contain HTML characters).
        if ($Guide) {
            # just in case someone is adding html code to the guide for whatever reason (HTML rendering is not allowed in the guide anymore on PasswordState)
            $Guide = [System.Net.WebUtility]::HtmlEncode($Guide)
            $body | Add-Member -NotePropertyName "Guide" -NotePropertyValue $Guide
        }
        # Adding API Key to the body if using APIKey as Authentication Type to use the api instead of winAPI
        $penv = Get-PasswordStateEnvironment
        if ($penv.AuthType -eq "APIKey") {
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $penv.Apikey
        }
        if ($PSCmdlet.ShouldProcess("$Name under folder $folderid")) {
            # Sort the CustomObject and then covert body to json and execute the api query
            $body = "$($body |ConvertTo-Json)"
            $output = New-PasswordStateResource -uri "/api/passwordlists" -body $body -Sort:$Sort
        }
    }

    end {
        if ($output) {
            return $output
        }
    }
}