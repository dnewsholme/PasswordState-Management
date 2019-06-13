<#
    .SYNOPSIS
    Finds a password state entry and returns the object. If multiple matches it will return multiple entries.

    .DESCRIPTION
    Finds a password state entry and returns the object. If multiple matches it will return multiple entries.

    .EXAMPLE
    PS C:\> Get-PasswordStatePassword
    Returns all passwords you have access to.

    .EXAMPLE
    PS C:\> Get-PasswordStatePassword "testuser"
    Returns the test user object including password.
    .EXAMPLE
    PS C:\> Get-PasswordStatePassword -Title '"testuser"'
    Returns the object including password, which is an exact match with the title (Requires double quotes for exact match).
    .EXAMPLE
    PS C:\> Get-PasswordStatePassword -Username "testuser2" -Notes "Test"
    Returns the test user 2 object, where the notes contain "Test", including password.
    .EXAMPLE
    PS C:\> Get-PasswordStatePassword -PasswordID "3456"
    Returns the object with the PasswordID 3456 including password.

    .PARAMETER Search
    A string value which will be matched with most fields in the database table.

    .PARAMETER PasswordID
    An ID of a specific password resource to return.

    .PARAMETER Title
    A string value which should match the passwordstate entry.
    .PARAMETER Username
    An optional parameter to filter searches to those with a certain username as multiple titles may have the same value.
    .PARAMETER HostName
    An optional parameter to filter the search on hostname.
    .PARAMETER Domain
    An optional parameter to filter the search on domain.
    .PARAMETER AccountType
    An optional parameter to filter the search on account type.
    .PARAMETER Description
    An optional parameter to filter the search on description.
    .PARAMETER Notes
    An optional parameter to filter the search on notes.
    .PARAMETER URL
    An optional parameter to filter the search on the URL.
    .PARAMETER SiteID
    An optional parameter to filter the search on the site ID.
    .PARAMETER SiteLocation
    An optional parameter to filter the search on the site location.
    .PARAMETER GenericField1
    An optional parameter to filter the search on a generic field.
    .PARAMETER GenericField2
    An optional parameter to filter the search on a generic field.
    .PARAMETER GenericField3
    An optional parameter to filter the search on a generic field.
    .PARAMETER GenericField4
    An optional parameter to filter the search on a generic field.
    .PARAMETER GenericField5
    An optional parameter to filter the search on a generic field.
    .PARAMETER GenericField6
    An optional parameter to filter the search on a generic field.
    .PARAMETER GenericField7
    An optional parameter to filter the search on a generic field.
    .PARAMETER GenericField8
    An optional parameter to filter the search on a generic field.
    .PARAMETER GenericField9
    An optional parameter to filter the search on a generic field.
    .PARAMETER GenericField10
    An optional parameter to filter the search on a generic field.

    .PARAMETER PasswordListID
    An optional parameter to filter the search on a specific password list.

    .PARAMETER Reason
    A reason which can be logged for auditing of why a password was retrieved.

    .OUTPUTS
    Returns the Object from the API as a powershell object.

    .NOTES
    2018 - Daryl Newsholme
    2019 - Jarno Colombeen
#>
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
        . "$(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordStateClass.ps1")"
        Add-Type -AssemblyName System.Web
        # Initalize output Array
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
            $obj = Get-PasswordStateResource -URI $uri @parms  -Method GET
            foreach ($i in $obj) {
                [PasswordResult]$i = $i
                $i.Password = [EncryptedPassword]$i.Password
                switch ($global:PasswordStateShowPasswordsPlainText) {
                    True {
                        $i.DecryptPassword()
                    }
                    Default {

                    }
                }
                Write-Output $i
            }

        }
        Catch {
            Throw $_.Exception
        }

    }
}