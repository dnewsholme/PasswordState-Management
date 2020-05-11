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
        [string]$ADDomainNetBIOS
    )

    begin {
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
        if ($Permission) {
            $body | Add-Member -NotePropertyName "Description" -NotePropertyValue $Description
        }
        # Adding API Key to the body if using APIKey as Authentication Type to use the api instead of winAPI
        $penv = Get-PasswordStateEnvironment
        if ($penv.AuthType -eq "APIKey") {
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $penv.Apikey
        }
        if ($PSCmdlet.ShouldProcess("Creating AD Security Group '$SecurityGroupName' for Domain '$ADDomainNetBIOS' (Description: '$Description')")) {
            # Covert body to json and execute the api query
            $body = "$($body |ConvertTo-Json)"
            $output = New-PasswordStateResource -uri "/api/securitygroup" -body $body -Sort:$Sort
        }
    }

    end {
        if ($output) {
            return $output
        }
    }
}