Function Move-PasswordStatePassword
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
    $PasswordListID
  )

  Process
  {
    $Body = [PSCustomObject]@{
      PasswordID = $PasswordID
      DestinationPasswordListID = $PasswordListID
    } | ConvertTo-Json

    If ($PSCmdlet.ShouldProcess("Move PasswordId:$PasswordID to PasswordListId:$PasswordListID"))
    {
      Set-PasswordStateResource -URI '/api/passwords/move' -Body $Body
    }
  }
}