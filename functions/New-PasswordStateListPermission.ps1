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
        [string]$ApplyPermissionsForSecurityGroupName = $null,
        [parameter(ValueFromPipelineByPropertyName, Position = 4, Mandatory = $false)]
        [switch]$Sort
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
        if ($PSCmdlet.ShouldProcess("PasswordListID $PasswordListID - Setting Permission '$Permission'. Applying to: User = '$ApplyPermissionsForUserID', SecurityGroup = '$ApplyPermissionsForSecurityGroupName' or SecurityGroupID = '$ApplyPermissionsForSecurityGroupID'")) {
            # Sort the CustomObject and then covert body to json and execute the api query
            $body = "$($body | ConvertTo-Json)"
            $output = New-PasswordStateResource -uri "/api/passwordlistpermissions" -body $body -Sort:$Sort
        }
    }

    end {
        if ($output) {
            return $output
        }
    }
}