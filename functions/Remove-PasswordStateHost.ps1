Function Remove-PasswordStateHost {
  [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = 'High')]
  Param (
    [Parameter(ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)][string]$HostName,
    [Parameter(ValueFromPipelineByPropertyName, Position = 1)][string]$Reason,
    [Parameter(ValueFromPipelineByPropertyName, Position = 2)][switch]$PreventAuditing
  )

  Process {
    If ($Reason)
    {
      $headerreason = @{'Reason' = "$reason"}
      $parms = @{ExtraParams = @{'Headers' = $headerreason}}
    }

    $uri = "/api/hosts/$HostName"

    If ($PreventAuditing.IsPresent)
    {
      $uri += '?PreventAuditing=True'
    }

    If ($PSCmdlet.ShouldProcess("$($HostName)"))
    {
      Try
      {
        Remove-PasswordStateResource -uri $uri @parms -method Delete
      }
      Catch
      {
        Throw $_.Exception
      }
    }
  }
}