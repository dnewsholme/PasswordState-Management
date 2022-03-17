Function Add-PasswordStateADSecurityGroup
{
  [CmdletBinding(SupportsShouldProcess = $true)]
  Param
  (
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [Alias('Identity', 'Group', 'Name')]
    [ValidateNotNullOrEmpty()]
    [string]
    $SecurityGroupName,

    [Parameter(Position = 1)]
    [ValidateLength(1, 1000)]
    [string]
    $Description,

    [Parameter(Position = 2)]
    [Alias('Domain')]
    [ValidateNotNullOrEmpty()]
    [string]
    $ADDomainNetBIOS = $env:USERDOMAIN,

    [Parameter(Position = 3)]
    [switch]
    $PreventAuditing
  )

  Begin
  {
    Add-Type -AssemblyName System.Web
  }

  Process
  {
    $Auditing = @('', '?PreventAuditing=true')[[bool]($PreventAuditing.IsPresent)]

    $Body = [PSCustomObject]@{
      SecurityGroupName = [System.Web.HttpUtility]::UrlEncode($SecurityGroupName)
      ADDomainNetBIOS   = [System.Web.HttpUtility]::UrlEncode($ADDomainNetBIOS)
    }

    If (-not ([string]::IsNullOrEmpty($Description)) -and -not ([string]::IsNullOrWhiteSpace($Description)))
    {
      $Body | Add-Member -MemberType NoteProperty -Name 'Description' -Value ([System.Web.HttpUtility]::UrlEncode($Description))
    }

    If ($PSCmdlet.ShouldProcess("SecurityGroupName:$SecurityGroupName ADDomainNetBIOS:$ADDomainNetBIOS Description:$Description"))
    {
      New-PasswordStateResource -URI ('/api/securitygroup/{0}' -f $Auditing) -Body ($Body | ConvertTo-Json)
    }
  }
}