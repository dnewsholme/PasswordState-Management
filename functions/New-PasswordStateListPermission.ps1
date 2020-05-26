function New-PasswordStateListPermission {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = '*UserID and *PasswordListID are not a user and not a password')]
    [cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)]
        [int32]$PasswordListID,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $true)]
        [ValidateSet('A', 'M', 'V')]
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
            A {
                $PermissionLevel = "Admin"
                $AvailablePermissionLevel = @("Modify", "View", "Mobile Access")
            }
            M {
                $PermissionLevel = "Modify"
                $AvailablePermissionLevel = @("Admin", "View", "Mobile Access")
            }
            V {
                $PermissionLevel = "View"
                $AvailablePermissionLevel = @("Admin", "Modify", "Mobile Access")
            }
        }
        if ($ApplyPermissionsForUserID) {
            try {
                $AllPermissions = Get-PasswordStatePermission -ReportID 24 -UserID $ApplyPermissionsForUserID -ErrorAction Stop
            }
            catch {
                $_.Exception
            }
            if ($AllPermissions) {
                foreach ($Permissions in $AllPermissions) {
                    if (($Permissions.PasswordListID -eq $PasswordListID) -and ($Permissions.$PermissionLevel -eq "Yes")) {
                        throw "Permission '$Permission' ($PermissionLevel) on PasswordList '$($Permissions.PasswordList)' (ID '$PasswordListID') for UserID '$ApplyPermissionsForUserID' already exists!"
                    }
                    elseif ($Permissions.PasswordListID -eq $PasswordListID) {
                        foreach ($AvailablePermission in $AvailablePermissionLevel) {
                            if ($Permissions.$AvailablePermission -eq "Yes") {
                                throw "UserID '$ApplyPermissionsForUserID' already has Permission '$AvailablePermission' on PasswordList '$($Permissions.PasswordList)' (ID '$PasswordListID')! Please use 'Set-PasswordStateListPermission -Permission '$Permission' -ApplyPermissionsForUserID '$ApplyPermissionsForUserID' -PasswordListID '$PasswordListID'' to update the permissions to type '$Permission' ($PermissionLevel)"
                            }
                        }
                    }
                }
            }
        }
        if ($ApplyPermissionsForSecurityGroupName) {
            try {
                $AllPermissions = Get-PasswordStatePermission -ReportID 25 -SecurityGroupName $ApplyPermissionsForSecurityGroupName -ErrorAction Stop
            }
            catch {
                $_.Exception
            }
            if ($AllPermissions) {
                foreach ($Permissions in $AllPermissions) {
                    if (($Permissions.PasswordListID -eq $PasswordListID) -and ($Permissions.$PermissionLevel -eq "Yes")) {
                        throw "Permission '$Permission' ($PermissionLevel) on PasswordList '$($Permissions.PasswordList)' (ID '$PasswordListID') for SecurityGroup '$ApplyPermissionsForSecurityGroupName' already exists!"
                    }
                    elseif ($Permissions.PasswordListID -eq $PasswordListID) {
                        foreach ($AvailablePermission in $AvailablePermissionLevel) {
                            if ($Permissions.$AvailablePermission -eq "Yes") {
                                throw "SecurityGroup '$ApplyPermissionsForSecurityGroupName' already has Permission '$AvailablePermission' on PasswordList '$($Permissions.PasswordList)' (ID '$PasswordListID')! Please use 'Set-PasswordStateListPermission -Permission '$Permission' -ApplyPermissionsForSecurityGroupName '$ApplyPermissionsForSecurityGroupName' -PasswordListID '$PasswordListID'' to update the permissions to type '$Permission' ($PermissionLevel)"
                            }
                        }
                    }
                }
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
            "PasswordListID"                       = $PasswordListID
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
        if ($PSCmdlet.ShouldProcess("PasswordListID $PasswordListID - Setting Permission '$Permission'. Applying to: User = '$ApplyPermissionsForUserID', SecurityGroup = '$ApplyPermissionsForSecurityGroupName' or SecurityGroupID = '$ApplyPermissionsForSecurityGroupID'")) {
            # Sort the CustomObject and then covert body to json and execute the api query
            $body = "$($body | ConvertTo-Json)"
            try {
                $output = New-PasswordStateResource -uri "/api/passwordlistpermissions" -body $body -ErrorAction Stop
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