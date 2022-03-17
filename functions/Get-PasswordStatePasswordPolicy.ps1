Function Get-PasswordStatePasswordPolicy
{
  [CmdletBinding(SupportsShouldProcess = $true)]
  Param
  (
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('Generator', 'Strength')]
    [string]
    $Type,
    
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
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
    $URI = '/api/password{0}/' -f $Type.ToLower()
    
    If (-not ([string]::IsNullOrEmpty($Search)) -and -not ([string]::IsNullOrWhiteSpace($Search)) -and -not ($Search -eq '*'))
    {
      $URI += '?search={0}' -f ([System.Web.HttpUtility]::UrlEncode($Search))
    }
    
    Get-PasswordStateResource -URI $URI
  }
}