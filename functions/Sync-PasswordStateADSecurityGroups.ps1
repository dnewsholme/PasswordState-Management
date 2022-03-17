Function Sync-PasswordStateADSecurityGroups
{
  Process
  {
    $URI = '/api/securitygroup/getadsync'

    Get-PasswordStateResource -URI $URI
  }
}