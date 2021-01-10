function New-PasswordStateADSecurityGroup {
    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)]
        [ValidateLength(0, 255)]
        [Alias("Name")]
        [string]$SecurityGroupName,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $false)]
        [ValidateLength(0, 255)]
        [string]$Description,
        [parameter(ValueFromPipelineByPropertyName, Position = 2, Mandatory = $true)]
        [string]$ADDomainNetBIOS,
        [parameter(ValueFromPipelineByPropertyName, Position = 3, Mandatory = $false)]
        [string]$Reason
    )

    begin {
        # Import PasswordState Environment for validation of PasswordsInPlainText setting
        $PWSProfile = Get-PasswordStateEnvironment
        # Add a reason to the audit log if specified
        If ($Reason) {
            $headerreason = @{"Reason" = "$Reason" }
            $parms = @{ExtraParams = @{"Headers" = $headerreason } }
        }
        else { $parms = @{ } }
    }
    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [PSCustomObject]@{
            "SecurityGroupName" = $SecurityGroupName
            "ADDomainNetBIOS"   = $ADDomainNetBIOS
        }
        # Add description if parameter was given.
        # Currently the description of PasswordState is NOT synced during import of an AD Security group when using the API.
        # If this will be implemented in the future, the description is optional and will not be sent as an empty string or null in the request.
        if ($Description) {
            $body | Add-Member -NotePropertyName "Description" -NotePropertyValue $Description
        }
        # Adding API Key to the body if using APIKey as Authentication Type to use the api instead of winAPI
        if ($PWSProfile.AuthType -eq "APIKey") {
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $PWSProfile.Apikey
        }
        if ($PSCmdlet.ShouldProcess("Creating AD Security Group '$SecurityGroupName' for Domain '$ADDomainNetBIOS' (Description: '$Description')")) {
            # Covert body to json and execute the api query
            $body = "$($body |ConvertTo-Json)"
            if ($body) {
                try {
                    $output = New-PasswordStateResource -uri "/api/securitygroup" -body $body @parms -ErrorAction Stop
                }
                catch {
                    throw $_.Exception
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