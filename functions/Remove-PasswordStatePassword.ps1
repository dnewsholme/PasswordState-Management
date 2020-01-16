function Remove-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
    )]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)][int32]$PasswordID,
        [parameter(ValueFromPipeline, Position = 1, Mandatory = $false)][Switch]$SendToRecycleBin,
        [parameter(ValueFromPipelineByPropertyName, Position = 2, Mandatory = $false)][string]$reason,
        [parameter(ValueFromPipelineByPropertyName, Position = 3)][switch]$PreventAuditing
    )

    begin {
    }

    process {
        If ($Reason) {
            $headerreason = @{"Reason" = "$reason"}
            $parms = @{ExtraParams = @{"Headers" = $headerreason}}
        }

        $BuildURL = '?'
        IF($SendToRecycleBin) {$BuildURL += "MoveToRecycleBin=$([System.Web.HttpUtility]::UrlEncode('True'))&"}
        Else{$BuildURL += "MoveToRecycleBin=$([System.Web.HttpUtility]::UrlEncode('False'))&"}
        If ($PreventAuditing) {$BuildURL += "PreventAuditing=$([System.Web.HttpUtility]::UrlEncode('True'))&"}
        $BuildURL = $BuildURL -Replace ".$"

        $uri = "/api/passwords/$($PasswordID)$($BuildURL)"

        if ($PSCmdlet.ShouldProcess("PasswordID:$($PasswordID) Recycle:$Sendtorecyclebin")) {
            try {
                Remove-PasswordStateResource -uri $uri @parms -method Delete
            }
            Catch {
                throw $_.Exception
            }
        }
    }
}