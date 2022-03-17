Function Sync-PasswordStateADSecurityGroups
{
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Function can only trigger all groups to sync')]
  Process
  {
    $URI = '/api/securitygroup/getadsync'

    Get-PasswordStateResource -URI $URI
  }
}