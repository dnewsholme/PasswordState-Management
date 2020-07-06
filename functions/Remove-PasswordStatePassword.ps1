function Remove-PasswordStatePassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
    )]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)][int32]$PasswordID,
        [parameter(ValueFromPipeline, Position = 1, Mandatory = $false)][Alias("MoveToRecycleBin")][Switch]$SendToRecycleBin,
        [parameter(ValueFromPipelineByPropertyName, Position = 2, Mandatory = $false)][string]$Reason,
        [parameter(ValueFromPipelineByPropertyName, Position = 3)][switch]$PreventAuditing
    )

    begin {
    }

    process {
        if ($Reason) {
            $headerreason = @{"Reason" = "$Reason" }
            $parms = @{ExtraParams = @{"Headers" = $headerreason } }
        }
        else { $parms = @{ } }

        $BuildURL = '?'
        if ($SendToRecycleBin.IsPresent) { $BuildURL += "MoveToRecycleBin=$([System.Web.HttpUtility]::UrlEncode('true'))&" }
        else { $BuildURL += "MoveToRecycleBin=$([System.Web.HttpUtility]::UrlEncode('false'))&" }
        if ($PreventAuditing.IsPresent) { $BuildURL += "PreventAuditing=$([System.Web.HttpUtility]::UrlEncode('true'))&" }
        $BuildURL = $BuildURL -Replace ".$"

        $uri = "/api/passwords/$($PasswordID)$($BuildURL)"

        if ($PSCmdlet.ShouldProcess("PasswordID:$($PasswordID) Recycle:$SendToRecycleBin")) {
            try {
                Remove-PasswordStateResource -uri $uri @parms -method Delete -ErrorAction Stop
            }
            Catch {
                throw $_.Exception
            }
            # When a delete command is issued, there is generally no confirmation from the API.
            Write-PSFMessage -Level Output -Message "The delete request was sent successfully."
        }
    }
}