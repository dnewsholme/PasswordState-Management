function New-PasswordStatePasswordPermission {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = '*UserID and *PasswordID are not a user and not a password')]
    [cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)]
        [int32]$PasswordID,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $true)]
        [ValidateSet('M', 'V')]
        [string]$Permission,
        [parameter(ValueFromPipelineByPropertyName, Position = 2, Mandatory = $false)]
        [ValidateLength(0, 100)]
        [string]$ApplyPermissionsForUserID = $null,
        [parameter(parameterSetName = 'PermissionID', Position = 3, ValueFromPipelineByPropertyName, Mandatory = $true)]
        [Nullable[System.Int32]]$ApplyPermissionsForSecurityGroupID = $null,
        [parameter(parameterSetName = 'PermissionName', Position = 3, ValueFromPipelineByPropertyName, Mandatory = $true)]
        [string]$ApplyPermissionsForSecurityGroupName = $null
    )

    begin {
        switch ($Permission) {
            M {
                $PermissionLevel = "Modify"
                $AvailablePermissionLevel = @("View")
            }
            V {
                $PermissionLevel = "View"
                $AvailablePermissionLevel = @("Modify")
            }
        }
        if ($ApplyPermissionsForUserID) {
            try {
                $AllPermissions = Get-PasswordStatePermission -ReportID 43 -ErrorAction Stop | Where-Object { ($_.UserID -eq $ApplyPermissionsForUserID) -and ($_.PasswordID -eq $PasswordID) }
            }
            catch {
                $_.Exception
            }
            if ($AllPermissions) {
                foreach ($Permissions in $AllPermissions) {
                    # We cannot identify if existing permissions were applied to password objects directly or on password lists. This is not supported for now with the api.
                    if (($Permissions.PasswordID -eq $PasswordID) -and ($Permissions.UserID -eq $ApplyPermissionsForUserID) -and ($Permissions.$PermissionLevel -eq "Yes")) {
                        throw "UserID '$ApplyPermissionsForUserID' already has directly or indirectly (PasswordList) permissions (Permission '$Permission' ($PermissionLevel)) on Password '$($Permissions.Title)' with ID '$PasswordID' (PasswordList: '$($Permissions.PasswordList)', Path: '$($Permissions.TreePath)')!"
                    }
                    elseif (($Permissions.PasswordID -eq $PasswordID) -and ($Permissions.UserID -eq $ApplyPermissionsForUserID)) {
                        foreach ($AvailablePermission in $AvailablePermissionLevel) {
                            if ($Permissions.$AvailablePermission -eq "Yes") {
                                throw "UserID '$ApplyPermissionsForUserID' has directly or indirectly (PasswordList) Permission '$AvailablePermission' on Password '$($Permissions.Title)' with ID '$PasswordID' (PasswordList: '$($Permissions.PasswordList)', Path: '$($Permissions.TreePath)')! Please use 'Set-PasswordStatePasswordPermission -Permission '$Permission' -ApplyPermissionsForUserID '$ApplyPermissionsForUserID' -PasswordID '$PasswordID'' to change the existing permissions."
                            }
                        }
                    }
                    else {
                        Write-PSFMessage -Level Verbose -Message "UserID '$ApplyPermissionsForUserID' does not have any permission on Password '$($Permissions.Title)' with ID '$PasswordID' (PasswordList: '$($Permissions.PasswordList)', Path: '$($Permissions.TreePath)') so far, moving on..."
                    }
                }
            }
            else {
                Write-PSFMessage -Level Verbose -Message "UserID '$ApplyPermissionsForUserID' does not have any permission on Password '$($Permissions.Title)' with ID '$PasswordID' (PasswordList: '$($Permissions.PasswordList)', Path: '$($Permissions.TreePath)') so far, moving on..."
            }
        }
        if ($ApplyPermissionsForSecurityGroupName) {
            try {
                $AllPermissions = Get-PasswordStatePermission -ReportID 43 -ErrorAction Stop | Where-Object { ($_.SecurityGroupName -eq $ApplyPermissionsForSecurityGroupName) -and ($_.PasswordID -eq $PasswordID) }
            }
            catch {
                $_.Exception
            }
            if ($AllPermissions) {
                foreach ($Permissions in $AllPermissions) {
                    # We cannot identify if existing permissions were applied to password objects directly or on password lists. This is not supported for now with the api.
                    if (($Permissions.PasswordID -eq $PasswordID) -and ($Permissions.SecurityGroupName -eq $ApplyPermissionsForSecurityGroupName) -and ($Permissions.$PermissionLevel -eq "Yes")) {
                        throw "SecurityGroup '$ApplyPermissionsForSecurityGroupName' already has directly or indirectly (PasswordList) permissions (Permission '$Permission' ($PermissionLevel)) on Password '$($Permissions.Title)' with ID '$PasswordID' (PasswordList: '$($Permissions.PasswordList)', Path: '$($Permissions.TreePath)')!"
                    }
                    elseif (($Permissions.PasswordID -eq $PasswordID) -and ($Permissions.SecurityGroupName -eq $ApplyPermissionsForSecurityGroupName)) {
                        foreach ($AvailablePermission in $AvailablePermissionLevel) {
                            if ($Permissions.$AvailablePermission -eq "Yes") {
                                throw "SecurityGroup '$ApplyPermissionsForSecurityGroupName' has directly or indirectly (PasswordList) Permission '$AvailablePermission' on Password '$($Permissions.Title)' with ID '$PasswordID' (PasswordList: '$($Permissions.PasswordList)', Path: '$($Permissions.TreePath)')! Please use 'Set-PasswordStatePasswordPermission -Permission '$Permission' -ApplyPermissionsForUserID '$ApplyPermissionsForUserID' -PasswordID '$PasswordID'' to change the existing permissions."
                            }
                        }
                    }
                    else {
                        Write-PSFMessage -Level Verbose -Message "SecurityGroup '$ApplyPermissionsForSecurityGroupName' does not have any permission on Password '$($Permissions.Title)' with ID '$PasswordID' (PasswordList: '$($Permissions.PasswordList)', Path: '$($Permissions.TreePath)') so far, moving on..."
                        break
                    }
                }
            }
            else {
                Write-PSFMessage -Level Verbose -Message "SecurityGroup '$ApplyPermissionsForSecurityGroupName' does not have any permission on Password '$($Permissions.Title)' with ID '$PasswordID' (PasswordList: '$($Permissions.PasswordList)', Path: '$($Permissions.TreePath)') so far, moving on..."
            }
        }
        if ($ApplyPermissionsForSecurityGroupID) {
            # Cannot validate SecurityGroupID for now because the api has not implemented a possibility to query the IDs of security groups in any method/report
            Continue
        }
    }
    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [PSCustomObject]@{
            "PasswordID"                           = $PasswordID
            "ApplyPermissionsForUserID"            = $ApplyPermissionsForUserID
            "ApplyPermissionsForSecurityGroupID"   = $ApplyPermissionsForSecurityGroupID
            "ApplyPermissionsForSecurityGroupName" = $ApplyPermissionsForSecurityGroupName
            "Permission"                           = $Permission
        }
        # Adding API Key to the body if using APIKey as Authentication Type to use the api instead of winAPI
        $penv = Get-PasswordStateEnvironment
        if ($penv.AuthType -eq "APIKey") {
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $penv.Apikey
        }
        if ($PSCmdlet.ShouldProcess("PasswordID $PasswordID - Setting Permission '$Permission'. Applying to: User = '$ApplyPermissionsForUserID', SecurityGroup = '$ApplyPermissionsForSecurityGroupName' or SecurityGroupID = '$ApplyPermissionsForSecurityGroupID'")) {
            # Sort the CustomObject and then covert body to json and execute the api query
            $body = "$($body | ConvertTo-Json)"
            try {
                $output = New-PasswordStateResource -uri "/api/passwordpermissions" -body $body -ErrorAction Stop
            }
            catch {
                throw $_.Exception
            }
        }
    }

    end {
        if ($output) {
            return $output
        }
    }
}