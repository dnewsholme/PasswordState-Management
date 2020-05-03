function Get-PasswordStateEnvironment {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory = $false)][string]$path = [Environment]::GetFolderPath('UserProfile')
    )

    begin {
        # Check to see if machine is running linux if so implement a fix for kerberos auth.
        if ($invokeIsLinux -eq $true){
            $env:DOTNET_SYSTEM_NET_HTTP_USESOCKETSHTTPHANDLER=0
        }
        if ($env:PASSWORDSTATEPROFILE){
            $path = $env:PASSWORDSTATEPROFILE
        }
        try {
            # Get Profile path
            if ($Script:Preferences.Path -ne '') {
                $profilepath=$Script:Preferences.Path
            } else {
                $profilepath = $path
            }
            # Read in the password state environment json config file.
            $content = Get-Content "$($profilepath)\passwordstate.json" -ErrorAction Stop
        }
        Catch {
            throw "No environment has been set. Run Set-PasswordStateEnvironment to create first."
        }
    }

    process {
        # Convert from json and decrypt the api key if the api key is used.
        $output = $content | ConvertFrom-Json
        if ($output.AuthType -eq "WindowsCustom") {
            $cred = New-Object System.Management.Automation.PSCredential -ArgumentList "$($output.Apikey.username)", $($output.apikey.Password | ConvertTo-SecureString)
            $output.apikey = $cred
        }
        elseif ($output.AuthType -eq "APIKey") {
            $cred = New-Object System.Management.Automation.PSCredential -ArgumentList "username", $($output.apikey | ConvertTo-SecureString)
            $apikey = $cred.GetNetworkCredential().Password
            $output.apikey = $apikey
        }
        if ($output.PasswordGeneratorAPIKey){
            $cred2 = New-Object System.Management.Automation.PSCredential -ArgumentList "username", $($output.PasswordGeneratorAPIKey | ConvertTo-SecureString)
            $pwgen = $cred2.GetNetworkCredential().Password
            $output.PasswordGeneratorAPIKey = $pwgen
        }
        if ($null -eq $output.TimeoutSeconds){
            $output | Add-Member -MemberType NoteProperty -Name "TimeoutSeconds" -Value 60
        }
    }

    end {
        Return $output
    }
}