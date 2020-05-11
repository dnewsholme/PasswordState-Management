Function Get-PasswordStatePermission {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
    )]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateScript( {
                if ($_ -notmatch '23|24|25|26|27|28|37|38|43|44') {
                    throw "Given ReportID '$_' is not a valid ReportID for auditing permission. Please specify one of the following IDs: '23', '24', '25', '26', '27', '28', '37', '38', '43', '44'. You can get all possible ReportIDs and their purpose for auditing permissions with 'Get-PasswordStatePermission -ShowReportIDs'"
                }
                else {
                    $true
                }
            })]
        [int32]$ReportID,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 0)][string]$UserID,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 1)][string]$SecurityGroupName,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 2, HelpMessage = "Possible values are 0 for current month, 1 for the past 30 days, and then any other integer representing the quantity of months.")]
        [AllowNull()]
        [Alias('Duration')]
        [Nullable[System.Int32]]$DurationInMonth,
        [Parameter(ValueFromPipelineByPropertyName, Position = 1, HelpMessage = "SiteID 0 = Default site 'Internal'")]
        [AllowNull()]
        [Nullable[System.Int32]]$SiteID = 0,
        [Parameter(ValueFromPipelineByPropertyName, Position = 2)][switch]$ShowReportIDs
    )

    begin {
        $col_ReportIDs = [ordered]@{
            "23" = "(Default) What permissions exist (all users and security groups)?"
            "24" = "What permissions exist for a user?"
            "25" = "What Permissions exist for a Security Group?"
            "26" = "What permissions have changed recently?"
            "43" = "What permissions exist for all shared password records?"
            "44" = "What permissions exist for all Host Folders?"
            "27" = "Who has been approved access to passwords recently?"
            "28" = "Who has been denied access to passwords recently?"
            "37" = "How many Administrators are there for each Shared Password List?"
            "38" = "How many Administrators are there for each Password Folder?"
        }
        If ($PSBoundParameters.ContainsKey('ShowReportIDs')) {
            $ReportIDs = $col_ReportIDs
        }
        else {
            $ReportIDs = $null
        }
    }
    process {
        # If -ShowReportIDs was specified, output the overview and return the table from this function
        if ($ReportIDs) {
            return $ReportIDs
        }
        # Use default report for all permissions if no ReportID was specified
        If (!($PSBoundParameters.ContainsKey('ReportID'))) {
            [int32]$ReportID = 23
        }
        if ($ReportID) {
            # Get the name for the report id
            [string]$ReportName = $col_ReportIDs."$($ReportID)"
            Switch ($PSCmdlet.ParameterSetName) {
                'All' {
                    If ($null -ne $SiteID) {
                        $BuildURL = [string]$ReportID + '?'
                        $BuildURL += "SiteID=$([System.Web.HttpUtility]::UrlEncode($SiteID))&"
                    }
                    else {
                        $BuildURL = $ReportID
                    }
                }
                'Specific' {
                    $BuildURL = [string]$ReportID + '?'
                    If ($UserID) { $BuildURL += "UserID=$([System.Web.HttpUtility]::UrlEncode($UserID))&" }
                    If ($SecurityGroupName) { $BuildURL += "SecurityGroupName=$([System.Web.HttpUtility]::UrlEncode($SecurityGroupName))&" }
                    If ($null -ne $SiteID) { $BuildURL += "SiteID=$([System.Web.HttpUtility]::UrlEncode($SiteID))&" }
                    If ($null -ne $DurationInMonth) { $BuildURL += "Duration=$([System.Web.HttpUtility]::UrlEncode($DurationInMonth))&" }
                }
            }
            if ($BuildURL) {
                $BuildURL = $BuildURL -Replace ".$"
                $uri = "/api/reporting/$($BuildURL)"
            }
            if ($PSCmdlet.ShouldProcess("Running report '$ReportName' (ID '$ReportID') for Site '$SiteID'. Specific options: User = '$UserID', SecurityGroup = '$SecurityGroupName', Duration =  '$DurationInMonth'")) {
                Try {
                    $output = Get-PasswordStateResource -uri $uri -method GET -ErrorAction Stop
                }
                Catch {
                    Throw $_.Exception
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

Set-Alias -Name Get-PasswordStateListPermission -Value Get-PasswordStatePermission -Force
Set-Alias -Name Get-PasswordStateFolderPermission -Value Get-PasswordStatePermission -Force
Set-Alias -Name Get-PasswordStatePasswordPermission -Value Get-PasswordStatePermission -Force