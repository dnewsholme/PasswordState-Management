Function Copy-PasswordStatePassword
{
  [CmdletBinding(SupportsShouldProcess = $true)]
  Param
  (
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [int32]
    $PasswordID,

    [Parameter(Mandatory = $true, Position = 1)]
    [Alias('DestinationPasswordListID')]
    [ValidateNotNullOrEmpty()]
    [int32]
    $PasswordListID,

    [Parameter(Position = 2)]
    [switch]
    $Link
  )

  Process
  {
    $Body = [PSCustomObject]@{
      PasswordID = $PasswordID
      DestinationPasswordListID = $PasswordListID
      Link = @('False', 'True')[[bool]($Link.IsPresent)]
    } | ConvertTo-Json

    New-PasswordStateResource -URI '/api/passwords/copy' -Body $Body
  }
}