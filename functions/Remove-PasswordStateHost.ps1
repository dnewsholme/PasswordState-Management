<#
    .SYNOPSIS
    Deletes a password state host.

    .DESCRIPTION
    Deletes a password state host.

    .EXAMPLE
    PS C:\> Remove-PasswordStateHost -HostName 'testhostname.domain'
    Deletes the host testhostname.domain.

    .PARAMETER HostName
    The exact hostname for the host you want to remove
    .PARAMETER Reason
    A reason which can be logged for auditing of why a host was removed.

    .PARAMETER PreventAuditing
    An optional parameter to prevent logging this API call in the audit log (Can be overruled in PasswordState preferences).

    .INPUTS
    HostName - The exact hostname for the host (String)

    .NOTES
    2019 - Jarno Colombeen
#>
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