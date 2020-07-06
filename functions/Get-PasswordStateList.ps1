Function Get-PasswordStateList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
    )]
    [CmdletBinding(DefaultParameterSetName = 'ID')]
    Param (
        [Parameter(ParameterSetName = 'ID', ValueFromPipelineByPropertyName, Position = 0)][int32]$PasswordListID,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 0)][string]$PasswordList,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 1)][string]$Description,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 2)][string]$TreePath,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 3)][int32]$SiteID,
        [Parameter(ParameterSetName = 'Specific', ValueFromPipelineByPropertyName, Position = 4)][string]$SiteLocation,
        [parameter(ValueFromPipelineByPropertyName, Position = 5)][switch]$PreventAuditing,
        [parameter(ValueFromPipelineByPropertyName, Position = 6)][string]$Reason

    )

    Begin {
        # Add a reason to the audit log if specified
        If ($Reason) {
            $headerreason = @{"Reason" = "$Reason" }
            $parms = @{ExtraParams = @{"Headers" = $headerreason } }
        }
        else { $parms = @{ } }
    }
    Process {
        Switch ($PSCmdlet.ParameterSetName) {
            'ID' {
                If (!($PSBoundParameters.ContainsKey('PasswordListID'))) {
                    $uri = "/api/passwordlists/"
                }
                else {
                    # if only PasswordListID is specified, so searching for a specific ID, PreventAuditing is not possible
                    $PreventAuditing = $false
                    $uri = "/api/passwordlists/$($PasswordListID)"
                }
            }
            'Specific' {
                $BuildURL = '?'
                If ($PasswordList) { $BuildURL += "PasswordList=$([System.Web.HttpUtility]::UrlEncode($PasswordList))&" }
                If ($Description) { $BuildURL += "Description=$([System.Web.HttpUtility]::UrlEncode($Description))&" }
                If ($TreePath) { $BuildURL += "TreePath=$([System.Web.HttpUtility]::UrlEncode($TreePath))&" }
                If ($SiteID) { $BuildURL += "SiteID=$([System.Web.HttpUtility]::UrlEncode($SiteID))&" }
                If ($SiteLocation) { $BuildURL += "SiteLocation=$([System.Web.HttpUtility]::UrlEncode($SiteLocation))&" }

                $BuildURL = $BuildURL -Replace ".$"

                $uri = "/api/searchpasswordlists/$($BuildURL)"
            }
        }
        Switch ($PreventAuditing) {
            $True {
                $uri += "&PreventAuditing=true"
            }
            Default {

            }
        }
        Try {
            Get-PasswordStateResource -uri $uri @parms -ErrorAction Stop
        }
        Catch {
            Throw $_.Exception
        }
    }
}

Set-Alias -Name Find-PasswordStateList -Value Get-PasswordStateList -Force