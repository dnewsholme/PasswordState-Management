<#
.SYNOPSIS
    Saves your password state environment configuration to be used when calling the rest api.
.DESCRIPTION
    Saves your password state environment configuration to be used when calling the rest api.
    This enables quickly calling the API without having to enter a key each time or the URL, the key is stored encrypted.
.PARAMETER baseuri
    The base url of the passwordstate server. eg https://passwordstate
.PARAMETER APIKey
    For use if APIKey is the preferred authentication method.
.PARAMETER WindowsAuthOnly
    For use if Windows Passthrough is the preferred authentication method.
.PARAMETER customcredentials
    For use if windows custom credentials is the preferred authentication method.
.EXAMPLE
    PS C:\> Set-PasswordStateEnvironment -baseuri "https://passwordstateserver" -UseWindowsAuthOnly
    Sets to use windows passthrough authentication to interact with the API
.EXAMPLE
    PS C:\> Set-PasswordStateEnvironment -baseuri "https://passwordstateserver" -APIKey "hdijdiwkjod9wu9dikwokd3uerunh"
    Sets to use an API key interact with the API. Note that password lists can only be retrieved with the System API key.
.INPUTS
    Baseuri - Should be the Password State URL without any parameters on it.
    UseWindowsAuthOnly - A switch value. (Don't use in conjunction with APIkey)
    APIkey - The APIkey for the passwordstate API
.OUTPUTS
    No Output
.NOTES
    Daryl Newsholme 2018
#>
function Set-PasswordStateEnvironment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'all passwords stored encrypted')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)][string]$Baseuri,
        [Parameter(ParameterSetName = 'One')][string]$Apikey,
        [Parameter(ParameterSetName = 'Two')][switch]$WindowsAuthOnly,
        [Parameter(ParameterSetName = 'Three')][pscredential]$customcredentials
    )

    begin {
        # Trim any trailing slashes.
        if ($Baseuri[-1] -eq "/") {
            $baseuri = $Baseuri.Trim("/")
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
    }

    process {
        # Build the custom object to be converted to JSON. Set APIKey as WindowsAuth if we are to use windows authentication.
        $json = New-Object psobject -Property @{
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
        }| ConvertTo-Json
    }

    end {
        $json | Out-File "$($env:USERPROFILE)\passwordstate.json"
    }
}