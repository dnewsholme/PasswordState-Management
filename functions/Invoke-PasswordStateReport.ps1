Function Invoke-PasswordStateReport {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'UserID and *PasswordListID* are not a user and not a password')]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ValueFromPipelineByPropertyName, Position = 0, HelpMessage = "Possible values: 1-49")]
        [ValidateScript( {
                if ($_ -notmatch '^([0-9]|[1-4][0-9])$') {
                    throw "Given ReportID '$_' is not a valid ReportID. Please specify a correct ReportID from 1-49. You can get all possible ReportIDs and their purpose with 'Invoke-PasswordStateReport -ShowReportIDs' or 'Invoke-PasswordStateReport -ShowAllReportIDs' for a list"
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
        [Nullable[Int32][]]
        $DurationInMonth,
        [Parameter(ValueFromPipelineByPropertyName, Position = 1, HelpMessage = "SiteID 0 = Default site 'Internal'")]
        [AllowNull()]
        [Nullable[Int32][]]
        $SiteID = 0,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 3)]
        [AllowNull()]
        [Nullable[Int32][]]
        $PasswordListIDs,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 4)][switch]$QueryExpiredPasswords,
        [Parameter(ValueFromPipelineByPropertyName, Position = 2)][switch]$ShowReportIDs,
        [Parameter(ValueFromPipelineByPropertyName, Position = 3)][switch]$ShowAllReportIDs
    )

    begin {
        $col_ReportIDs = [ordered]@{
            "User Reports"     = [ordered]@{
                "1"  = "What passwords can a user see?"
                "2"  = "What passwords does a user still know?"
                "3"  = "What has a user been doing lately?"
                "4"  = "What Failed login attempts have there been?"
                "5"  = "Who hasn't logged in recently?"
                "6"  = "Who has one or more Security Administrator roles?"
                "7"  = "What Remote Sessions has a user been doing lately?"
                "8"  = "What user accounts are currently disabled?"
                "9"  = "What user accounts are set to expire?"
                "10" = "Which users have logged in using the Emergency Access account?"
                "11" = "What user account impersonation has been occurring?"
                "41" = "What authentication option is applied for each user?"
            }
            "Passwords"        = [ordered]@{
                "12" = "What passwords have failed Heartbeat?"
                "13" = "What passwords have failed Reset?"
                "14" = "What passwords require checkout?"
                "15" = "What passwords are currently checked out?"
                "16" = "What passwords require a Reason to be specified for access?"
                "17" = "What passwords are expiring soon?"
                "18" = "What passwords have recently been reset?"
                "19" = "What password values have been reused?"
                "20" = "What passwords have not been used lately?"
                "21" = "What Passwords are not being synced?"
                "36" = "Show Passwords configured for resets and their dependencies"
                "22" = "Passwords Strength Compliance Status"
                "35" = "Have I Been Pwned Compromises"
            }
            "Permissions"      = [ordered]@{
                "23" = "What permissions exist (all users and security groups)?"
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
            "Activity"         = [ordered]@{
                "29" = "Remote Session Launcher Activity"
                "30" = "Browser Extension Activity"
                "31" = "Mobile Client Activity"
                "32" = "API Activity"
                "33" = "Self Destruct Activity"
                "34" = "Passive High Availability Module Activity"
            }
            "Document Reports" = [ordered]@{
                "45" = "What documents have been uploaded into Password Folders?"
                "46" = "What documents have been uploaded into Password Lists?"
                "47" = "What documents have been uploaded into Password records?"
                "48" = "What documents have been uploaded into Host Folders?"
                "49" = "What documents have been uploaded into Host records?"
            }
            "Misc Reports"     = [ordered]@{
                "39" = "Where are Privileged Account Credentials currently being used?"
                "40" = "What security groups exist, and who are their members?"
                "42" = "What Host records exist in Passwordstate?"
            }
        }
        # Generate a hashtable with all values from the nested hashtable
        $col_AllReportIDs = [ordered]@{ }
        foreach ($Key in $col_ReportIDs.Keys) {
            foreach ($SubKey in $col_ReportIDs[$Key].Keys) {
                $col_AllReportIDs.Add($SubKey, $col_ReportIDs[$Key][$SubKey])
            }
        }
        # if -ShowAllReportIDs is applied, show a full list of the hashtable values
        If ($PSBoundParameters.ContainsKey('ShowAllReportIDs')) {
            $ReportIDs = $col_AllReportIDs
        }
        # if -ShowReportIDs is applied, show a a structured list with categories of the hashtable values
        ElseIf ($PSBoundParameters.ContainsKey('ShowReportIDs')) {
            $ReportIDs = $col_ReportIDs
        }
        else {
            $ReportIDs = $null
        }
    }
    process {
        # If -ShowReportIDs or -ShowAllReportIDs was specified, output the overview and return the table from this function
        if ($ReportIDs) {
            return $ReportIDs
        }
        # Use default report for all permissions if no ReportID was specified
        If (!($PSBoundParameters.ContainsKey('ReportID'))) {
            throw "Error: No ReportID specified, please specify a valid ReportID from 1-49. You can get all possible ReportIDs and their purpose with 'Invoke-PasswordStateReport -ShowReportIDs' or 'Invoke-PasswordStateReport -ShowAllReportIDs' for a list"
        }
        if ($ReportID) {
            # Get the name for the report id
            [string]$ReportName = $col_AllReportIDs."$($ReportID)"
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
                    If ($null -ne $PasswordListIDs) { $BuildURL += "PasswordListIDs=$([System.Web.HttpUtility]::UrlEncode($PasswordListIDs))&" }
                    If ($QueryExpiredPasswords.IsPresent) { $BuildURL += "QueryExpiredPasswords=$([System.Web.HttpUtility]::UrlEncode($QueryExpiredPasswords))&" }
                }
            }
            if ($BuildURL) {
                $BuildURL = $BuildURL -Replace ".$"
                $uri = "/api/reporting/$($BuildURL)"
            }
            if ($PSCmdlet.ShouldProcess("Running report '$ReportName' (ID '$ReportID') for Site '$SiteID'. Specific options: User = '$UserID', SecurityGroup = '$SecurityGroupName', Duration =  '$DurationInMonth', PasswordListIDs = '$PasswordListIDs', QueryExpiredPasswords = '$QueryExpiredPasswords'")) {
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