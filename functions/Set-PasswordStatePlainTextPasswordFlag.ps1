<#
.SYNOPSIS
Sets a flag to return objects from passwordstate in plaintext

.DESCRIPTION
Allows passwords to be returned from the api without being stored as encrypted strings.

.EXAMPLE
Set-PasswordStatePlainTextPasswordFlag

.NOTES
Daryl Newsholme 2019
#>
function Set-PasswordStatePlainTextPasswordFlag {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Global var is very specific.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Intended behaviour')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
    )

    begin {

    }

    process {
        '$global:PasswordStateShowPasswordsPlainText = $true' | out-file $profile -Append
        $global:PasswordStateShowPasswordsPlainText = $true
    }

    end {
    }
}

