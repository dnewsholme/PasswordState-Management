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

