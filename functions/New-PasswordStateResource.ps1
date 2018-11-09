<#
.SYNOPSIS
   A function to simplify the Creation of password state resources via the rest API
.DESCRIPTION
    A function to simplify the Creation of password state resources via the rest API.
.EXAMPLE
    PS C:\> New-PasswordStateResource -uri "/api/passwords" -body $body
    Sets a password on the password api.
.PARAMETER URI
    The api resource to access such as /api/lists
.PARAMETER Body
    The body to be submitted in the rest request it should be in JSON format.
.PARAMETER Method
    Optional Parameter to override the method from POST.
.PARAMETER ContentType
    Optional Parameter to override the default content type from application/json.
.PARAMETER ExtraParams
    Optional Parameter to allow extra parameters to be passed to invoke-restmethod. Should be passed as a hashtable.
.OUTPUTS
    Will return the response from the rest API.
.NOTES
    Daryl Newsholme 2018
#>
function New-PasswordStateResource {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string]$uri,
        [string]$method = "POST",
        [string]$body = $null,
        [string]$ContentType = "application/json",
        [hashtable]$extraparams = $null

    )

    begin {
        # Force TLS 1.2
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $passwordstateenvironment = $(Get-PasswordStateEnvironment)
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
            "Body"            = $body
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
                    Write-Verbose "using uri $($params.uri)"
                    # Hit the api with windows auth
                    $result = Invoke-RestMethod @params -UseDefaultCredentials -TimeoutSec 60
                }
            }
        }
    }

    end {
        return $result
    }
}