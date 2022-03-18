Function Sync-PasswordStateADSecurityGroups
{
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Function can only trigger all groups to sync')]
  [CmdletBinding(SupportsShouldProcess = $true)]
  Param
  (
  )

  Process
  {
    $URI = '/api/securitygroup/getadsync'

    If ($PSCmdlet.ShouldProcess('Manually trigger synchronization'))
    {
      Get-PasswordStateResource -URI $URI
    }
  }
}