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

