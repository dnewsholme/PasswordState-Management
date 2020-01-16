function Get-PasswordStatePasswordHistory {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Needed for backward compatability')]
    [CmdletBinding()]
    [OutputType('System.Object[]')]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0)][int32]$PasswordID,
        [parameter(ValueFromPipelineByPropertyName, Position = 1, Mandatory = $false)][string]$reason,
        [parameter(ValueFromPipelineByPropertyName, Position = 2)][switch]$PreventAuditing

    )

    begin {
        . "$(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordStateClass.ps1")"
        $output = @()
    }

    process {
        If ($Reason) {
            $headerreason = @{"Reason" = "$reason"}
            $parms = @{ExtraParams = @{"Headers" = $headerreason}}
        }
        Else {
            $parms = @{}
        }
        $uri = "/api/passwordhistory/$($PasswordID)"
        Switch ($PreventAuditing) {
            $True {
                $uri += "&PreventAuditing=true"
            }
            Default {

            }
        }
        $results = Get-PasswordStateResource -uri $uri @parms
        Foreach ($result in $results) {
            $result = [PasswordHistory]$result
            $result.Password = [EncryptedPassword]$result.Password
            $output += $result
        }
    }

    end {
        switch ($global:PasswordStateShowPasswordsPlainText) {
            True {
                $output.DecryptPassword()
            }
        }
        Return $output
    }
}