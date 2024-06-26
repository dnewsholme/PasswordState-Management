﻿<#
.SYNOPSIS
   A function to simplify the modification/updates of password state resources via the rest API
.DESCRIPTION
       A function to simplify the modification/updates of password state resources via the rest API.
.EXAMPLE
    PS C:\> Set-PasswordStateResource -uri "/api/passwords" -body "{"Password":"somevalue","PasswordID":"7"}
    Sets a password on the password api.
.PARAMETER URI
    The api resource to access such as /api/lists
.PARAMETER Body
    The body to be submitted in the rest request it should be in JSON format.
.PARAMETER Method
    Optional Parameter to override the method from PUT.
.PARAMETER ContentType
    Optional Parameter to override the default content type from application/json.
.PARAMETER ExtraParams
    Optional Parameter to allow extra parameters to be passed to invoke-restmethod. Should be passed as a hashtable.
.OUTPUTS
    Will return the response from the rest API.
.NOTES
    Daryl Newsholme 2018
#>
function Set-PasswordStateResource {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string]$uri,
        [string]$method = "PUT",
        [string]$body = $null,
        [string]$ContentType = "application/json",
        [hashtable]$extraparams = $null
    )

    begin {
        $passwordstateenvironment = $(Get-PasswordStateEnvironment)
        # If the apikey is windowsauth then rebuild the uri string to match the windows auth apis, otherwise just build the api headers.
        Switch ($passwordstateenvironment.AuthType) {
            WindowsIntegrated {
                $uri = $uri -Replace "^/api/", "/winapi/"
            }
            WindowsCustom {
                $uri = $uri -Replace "^/api/", "/winapi/"
            }
            APIKey {
                $headers = @{"APIKey" = "$($passwordstateenvironment.Apikey)" }
            }
        }
    }

    process {
        $params = @{
            "UseBasicParsing" = $true
            "URI"             = "$($passwordstateenvironment.baseuri)$uri"
            "Method"          = $method.ToUpper()
            "ContentType"     = $ContentType
            "Body"            = [System.Text.Encoding]::UTF8.GetBytes($body)
        }
        if ($body) {
            Write-PSFMessage -Level Verbose -Message "Using body $($body)"
        }
        else {
            $params.Remove("Body")
        }
        if ($headers -and $null -ne $extraparams.Headers) {
            Write-Verbose "[$(Get-Date -format G)] Adding API Headers and extra param headers"
            $headers += $extraparams.headers
            $params += @{"headers" = $headers }
            $skipheaders = $true
        }
        if ($extraparams) {
            $extraparams.remove("headers") # headers already added dont try and add them again.
            Write-Verbose "[$(Get-Date -format G)] Adding extra parameter $($extraparams.keys) $($extraparams.values)"
            $params += $extraparams
        }

        if ($headers -and $skipheaders -ne $true) {
            Write-Verbose "[$(Get-Date -format G)] Adding API Headers only"
            $params += @{"headers" = $headers }
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