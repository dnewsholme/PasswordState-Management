<#
.SYNOPSIS
   A function to simplify the deletion of password state resources via the rest API
.DESCRIPTION
    A function to simplify the deletion of password state resources via the rest API.
.EXAMPLE
    PS C:\> Remove-PasswordStateResource -uri "/api/lists?LISTID"
    Removes a password list on the password api.
.PARAMETER URI
    The api resource to access such as /api/lists
.PARAMETER Method
    Optional Parameter to override the method from Delete.
.PARAMETER ContentType
    Optional Parameter to override the default content type from application/json.
.PARAMETER ExtraParams
    Optional Parameter to allow extra parameters to be passed to invoke-restmethod. Should be passed as a hashtable.
.OUTPUTS
    Will return the response from the rest API.
.NOTES
    Daryl Newsholme 2018
#>
function Remove-PasswordStateResource {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string]$uri,
        [string]$method = "DELETE",
        [string]$ContentType = "application/json",
        [hashtable]$extraparams = $null
    )

    begin {
        # Force TLS 1.2
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        # Import the environment
        $passwordstateenvironment = $(Get-PasswordStateEnvironment)
        # If the apikey is windowsauth then rebuild the uri string to match the windows auth apis, otherwise just build the api headers.
        Switch ($passwordstateenvironment.AuthType) {
            WindowsIntegrated {
                $uri = $uri.Replace("api", "winapi")
            }
            WindowsCustom {
                $uri = $uri.Replace("api", "winapi")
            }
            APIKey {
                $headers = @{"APIKey" = "$($passwordstateenvironment.Apikey)"}
            }
        }
    }

    process {
        $params = @{
            "UseBasicParsing" = $true
            "URI"             = "$($passwordstateenvironment.baseuri)$uri"
            "Method"          = $method.ToUpper()
            "ContentType"     = $ContentType
        }
        if ($extraparams) {
            $params += $extraparams
        }
        if ($headers) {
            $params += $headers
        }
        if ($PSCmdlet.ShouldProcess("[$($params.Method)] uri:$($params.uri) Headers:$($headers) Body:$($params.body)")) {
            Switch ($passwordstateenvironment.AuthType) {
                APIKey {
                    # Hit the API with the headers
                    Write-Verbose "using uri $($params.uri)"
                    $result = Invoke-RestMethod @params -TimeoutSec 60
                }
                WindowsCustom {
                    Write-Verbose "using uri $($params.uri)"
                    $result = Invoke-RestMethod @params -Credential $passwordstateenvironment.apikey -TimeoutSec 60
                }
                WindowsIntegrated {
                    # Hit the api with windows auth
                    Write-Verbose "using uri $($params.uri)"
                    $result = Invoke-RestMethod @params -UseDefaultCredentials -TimeoutSec 60
                }
            }
        }
    }

    end {
        return $result
    }
}