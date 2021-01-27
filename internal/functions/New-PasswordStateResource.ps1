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
.PARAMETER Sort
    Optional Parameter to sort the returned output.
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
        [hashtable]$extraparams = $null,
        [switch]$Sort
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting New-PasswordStateResource"
        $PasswordStateEnvironment = $(Get-PasswordStateEnvironment)
        Write-PSFMessage -Level Verbose -Message "Authentication mode = `"$($PasswordStateEnvironment.AuthType)`""
        Switch ($PasswordStateEnvironment.AuthType) {
            WindowsIntegrated {
                $uri = $uri -Replace "^/api/", "/winapi/"
            }
            WindowsCustom {
                $uri = $uri -Replace "^/api/", "/winapi/"
            }
            APIKey {
                $headers = @{"APIKey" = "$($PasswordStateEnvironment.Apikey)" }
            }
        }
    }

    process {
        $params = @{
            "UseBasicParsing" = $true
            "URI"             = "$($PasswordStateEnvironment.baseuri)$uri"
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
            Write-PSFMessage -Level Verbose -Message "Adding API Headers and extra param headers"
            $headers += $extraparams.headers
            $params += @{"headers" = $headers }
            $skipheaders = $true
        }
        if ($extraparams -and $null -eq $extraparams.Headers) {
            Write-PSFMessage -Level Verbose -Message "Adding extra parameter $($extraparams.keys) $($extraparams.values)"
            $params += $extraparams
        }

        if ($headers -and $skipheaders -ne $true) {
            Write-PSFMessage -Level Verbose -Message "Adding API Headers only"
            $params += @{"headers" = $headers }
        }
        if ($PSCmdlet.ShouldProcess("[$($params.Method)] uri:$($params.uri) Headers:$($headers) Body:$($params.body)")) {
            try {
                Switch ($PasswordStateEnvironment.AuthType) {
                    APIKey {
                        # Hit the API with the headers
                        Write-PSFMessage -Level Verbose -Message "Using uri $($params.uri) in APIKey mode"
                        $result = Invoke-RestMethod @params -TimeoutSec $PasswordStateEnvironment.TimeoutSeconds
                    }
                    WindowsCustom {
                        Write-PSFMessage -Level Verbose -Message "Using uri $($params.uri) in WinAPI custom credential mode"
                        $result = Invoke-RestMethod @params -Credential $PasswordStateEnvironment.apikey -TimeoutSec $PasswordStateEnvironment.TimeoutSeconds
                    }
                    WindowsIntegrated {
                        Write-PSFMessage -Level Verbose -Message "Using uri $($params.uri) in WinAPI mode"
                        # Hit the api with windows auth
                        $result = Invoke-RestMethod @params -UseDefaultCredentials -TimeoutSec $PasswordStateEnvironment.TimeoutSeconds
                    }
                }
            }
            catch [System.Net.WebException] {
                Write-PSFMessage -Level Verbose -Message "The request to Passwordstate timed out after $($PasswordStateEnvironment.TimeoutSeconds)"
                Write-Error -Exception $_.Exception -Message "The request to Passwordstate timed out after $($PasswordStateEnvironment.TimeoutSeconds)"
                throw "Passwordstate did not respond within the allotted time of $($PasswordStateEnvironment.TimeoutSeconds) seconds"
            }

        }
        if ($sort) {
            Write-PSFMessage -Level Warning -Message "Feature is currently not implemented"
        }
    }

    end {
        if ($result) {
            return $result
        }
        Write-PSFMessage -Level Verbose -Message 'End of New-PasswordStateResource'
    }
}