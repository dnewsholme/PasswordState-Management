function Set-PasswordStateEnvironment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'all passwords stored encrypted')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlaintextForPassword', '', Justification = 'no password')]
    [CmdletBinding(DefaultParameterSetName = "Two", SupportsShouldProcess = $true)]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory = $true)][string]$Baseuri,
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName = 'One')][string]$Apikey,
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName = 'One')][string]$PasswordGeneratorAPIkey,
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName = 'Two')][switch]$WindowsAuthOnly,
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName = 'Three')][pscredential]$customcredentials,
        [Parameter(ValueFromPipelineByPropertyName,Mandatory = $false)][string]$path = [Environment]::GetFolderPath('UserProfile')

    )

    begin {
        # ensure the uri is always in the correct format.
        $uri = ([uri]$Baseuri)
        if ($uri.IsDefaultPort -eq $true){
            $Baseuri = '{0}://{1}' -f $uri.Scheme,$uri.DnsSafeHost
        }
        Else {
            $Baseuri = '{0}://{1}:{2}' -f $uri.Scheme,$uri.Host,$uri.Port
        }
        if ($WindowsAuthOnly -eq $true) {
            $AuthType = "WindowsIntegrated"
        }
        Elseif ($customcredentials) {
            $AuthType = "WindowsCustom"
        }
        Else {
            $AuthType = "APIKey"
        }
        if ($env:PASSWORDSTATEPROFILE){
            $path = $env:PASSWORDSTATEPROFILE
        }
        $profilepath = $path
    }

    process {
        # Build the custom object to be converted to JSON. Set APIKey as WindowsAuth if we are to use windows authentication.
        $json = [pscustomobject] @{
            "TimeoutSeconds" = 60
            "Baseuri"  = $Baseuri
            "Apikey"   = switch ($AuthType) {
                WindowsIntegrated {
                    ""
                }
                WindowsCustom {
                    [pscustomobject]@{
                        "username" = $customcredentials.UserName
                        "Password" = ($customcredentials.Password | ConvertFrom-SecureString)
                    }
                }
                APIKey {
                    ($Apikey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString)

                }
            }
            "AuthType" = $AuthType
        }
        if ($PasswordGeneratorAPIkey){
            $json | Add-Member -MemberType NoteProperty -Name PasswordGeneratorAPIKey -Value ($PasswordGeneratorAPIkey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString)
        }
        $json = $json | ConvertTo-Json
    }

    end {
        if ($PSCmdlet.ShouldProcess("$($profilepath)\passwordstate.json")) {
            $json | Out-File "$($profilepath)\passwordstate.json"
            $Script:Preferences.Path=$profilepath
        }
    }
}