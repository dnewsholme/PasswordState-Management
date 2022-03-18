Function Get-PasswordStateADSecurityGroup
{
  Param
  (
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Search
  )

  Begin
  {
    Add-Type -AssemblyName System.Web
  }

  Process
  {
    $URI = '/api/getsecuritygroup/'

    If (-not ([string]::IsNullOrEmpty($Search)) -and -not ([string]::IsNullOrWhiteSpace($Search)) -and -not ($Search -eq '*'))
    {
      $URI += '?search={0}' -f ([System.Web.HttpUtility]::UrlEncode($Search))
    }

    Get-PasswordStateResource -URI $URI
  }
}