function Set-PasswordStateFolderPermission {
    [cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'All')]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)]
        [int32]$FolderID,
        [parameter(Position = 1, ValueFromPipelineByPropertyName, Mandatory = $true)]
        [ValidateSet('A', 'M', 'V')]
        [string]$Permission,
        [parameter(Position = 2, ValueFromPipelineByPropertyName, Mandatory = $false)]
        [ValidateLength(0, 100)]
        [string]$ApplyPermissionsForUserID = $null,
        [parameter(parameterSetName = 'PermissionID', Position = 3, ValueFromPipelineByPropertyName, Mandatory = $true)]
        [string]$ApplyPermissionsForSecurityGroupID = $null,
        [parameter(parameterSetName = 'PermissionName', Position = 3, ValueFromPipelineByPropertyName, Mandatory = $true)]
        [string]$ApplyPermissionsForSecurityGroupName = $null
    )

    begin {
    }
    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [PSCustomObject]@{
            "FolderID"                             = $FolderID
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
        if ($PSCmdlet.ShouldProcess("Folder $FolderID - Setting Permission '$Permission'. Applying to: User = '$ApplyPermissionsForUserID', SecurityGroup = '$ApplyPermissionsForSecurityGroupName' or SecurityGroupID = '$ApplyPermissionsForSecurityGroupID'")) {
            # Sort the CustomObject and then covert body to json and execute the api query
            $body = "$($body | ConvertTo-Json)"
            try {
                $output = Set-PasswordStateResource -uri "/api/folderpermissions" -body $body -ErrorAction Stop
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
Set-Alias -Name Update-PasswordStateFolderPermission -Value Set-PasswordStateFolderPermission -Force