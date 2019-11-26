<#
.SYNOPSIS
Removes the flag to specify to return password objects in plain text from password state.

.DESCRIPTION
Removes the flag to specify to return password objects in plain text from password state.

.EXAMPLE
Remove-PasswordStatePlainTextPasswordFlag

.NOTES
Daryl Newsholme 2019
#>
function Remove-PasswordStatePlainTextPasswordFlag {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
    )

    begin {

    }

    process {
        $psprofile = Get-Content $profile -Raw
        $psprofile = $psprofile.Replace('$global:PasswordStateShowPasswordsPlainText = $true','')
        $psprofile| out-file $profile -Force
        Remove-Variable PasswordStateShowPasswordsPlainText -Scope Global
    }

    end {
    }
}

