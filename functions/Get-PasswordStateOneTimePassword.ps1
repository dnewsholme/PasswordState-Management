Function Get-PasswordStateOneTimePassword
{
  Param
  (
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [int32]
    $PasswordID
  )

  Process
  {
    $URI = '/api/onetimepassword/{0}' -f $PasswordID

    Get-PasswordStateResource -URI $URI
  }
}