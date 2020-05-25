function Remove-PasswordStateListPermission {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = '*UserID and *PasswordListID are not a user and not a password')]
    [cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)]
        [int32]$PasswordListID,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $false)]
        [AllowNull()]
        [ValidateSet('A', 'M', 'V')]
        [string]$Permission = $null,
        [parameter(ValueFromPipelineByPropertyName, Position = 2, Mandatory = $false)]
        [ValidateLength(0, 100)]
        [string]$ApplyPermissionsForUserID = $null,
        [parameter(parameterSetName = 'PermissionID', Position = 3, ValueFromPipelineByPropertyName, Mandatory = $true)]
        [Nullable[System.Int32]]$ApplyPermissionsForSecurityGroupID = $null,
        [parameter(parameterSetName = 'PermissionName', Position = 3, ValueFromPipelineByPropertyName, Mandatory = $true)]
        [string]$ApplyPermissionsForSecurityGroupName = $null
    )

    begin {
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
        if ($PSCmdlet.ShouldProcess("PasswordListID $PasswordListID - Removing Permissions (Permission: '$Permission') for: User = '$ApplyPermissionsForUserID', SecurityGroup = '$ApplyPermissionsForSecurityGroupName' or SecurityGroupID = '$ApplyPermissionsForSecurityGroupID'")) {
            # Sort the CustomObject and then covert body to json and execute the api query
            $body = "$($body | ConvertTo-Json)"
            try {
                $output = Remove-PasswordStateResource -uri "/api/passwordlistpermissions" -Body $body -ErrorAction Stop
            }
            catch {
                throw $_.Exception
            }
            # When a delete command is issued, there is generally no confirmation from the API.
            Write-PSFMessage -Level Output -Message "The delete request was sent successfully."
        }
    }

    end {
        if ($output) {
            return $output
        }
    }
}