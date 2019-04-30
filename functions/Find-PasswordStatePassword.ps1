<#
    .SYNOPSIS
    Finds a password state entry and returns the object. If multiple matches it will return multiple entries.
    .DESCRIPTION
    Finds a password state entry and returns the object. If multiple matches it will return multiple entries.
    .EXAMPLE
    PS C:\> Find-PasswordStatePassword -title "testuser"
    Returns the test user object including password.
    .PARAMETER title
    A string value which should match the passwordstate entry exactly(Not case sensitive)
    .PARAMETER Username
    An optional parameter to filter searches to those with a certain username as multiple titles may have the same value.
    .PARAMETER PasswordID
    An ID of a specific password resource to return.
    .PARAMETER Reason
    A reason which can be logged for auditing of why a password was retrieved.
    .INPUTS
    Title - The title of the entry (string)
    Username - The username you need the password for. If multiple entries have the same name this is useful to get the one you want only. (String)(Optional)
    .OUTPUTS
    Returns the Object from the API as a powershell object.
    .NOTES
    Daryl Newsholme 2018
#>
Function Find-PasswordStatePassword
{
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'No Password is used only ID.')]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'PasswordID isnt a password')]
  [CmdletBinding(DefaultParameterSetName='General')]
  Param
  (
    [Parameter(ParameterSetName='General',ValueFromPipeline,ValueFromPipelineByPropertyName,Position=0,Mandatory=$true)][ValidateNotNullOrEmpty()][string]$Search,
    [Parameter(ParameterSetName='PasswordID',ValueFromPipelineByPropertyName,Position=0,Mandatory=$true)][ValidateNotNullOrEmpty()][int32]$PasswordID,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=0)][string]$Title,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=1)][string]$UserName,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=2)][string]$HostName,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=3)][string]$Domain,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=4)][string]$AccountType,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=5)][string]$Description,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=6)][string]$Notes,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=7)][string]$URL,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=8)][string]$SiteID,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=9)][string]$SiteLocation,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=10)][string]$GenericField1,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=11)][string]$GenericField2,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=12)][string]$GenericField3,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=13)][string]$GenericField4,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=14)][string]$GenericField5,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=15)][string]$GenericField6,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=16)][string]$GenericField7,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=17)][string]$GenericField8,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=18)][string]$GenericField9,
    [Parameter(ParameterSetName='Specific',ValueFromPipelineByPropertyName,Position=19)][string]$GenericField10,
    [parameter(ValueFromPipelineByPropertyName, Position = 5)][string]$Reason
  )
  
  Begin
  {
    # Create Class
    class PasswordResult
    {
      # Properties
      [int]$PasswordID
      [String]$Title
      [String]$Username
      [String]$Password
      [String]$Description
      [String]$Domain
      # Hidden Properties
      hidden [String]$hostname
      hidden [String]$GenericField1
      hidden [String]$GenericField2
      hidden [String]$GenericField3
      hidden [String]$GenericField4
      hidden [String]$GenericField5
      hidden [String]$GenericField6
      hidden [String]$GenericField7
      hidden [String]$GenericField8
      hidden [String]$GenericField9
      hidden [String]$GenericField10
      hidden [int]$AccountTypeID
      hidden [string]$notes
      hidden [string]$URL
      hidden [string]$ExpiryDate
      hidden [string]$allowExport
      hidden [string]$accounttype

    }
    #Initalize output Array
    $output = @()
  }

  Process
  {
    If ($Reason)
    {
      $headerreason = @{"Reason" = "$reason"}
    }
    # search each list for the password title (exclude the passwords so it doesn't spam audit logs with lots of read passwords)
    <#if ($PasswordID) {
      $tempobj = [PSCustomObject]@{
        PasswordID = $PasswordID
      }
    }#>
    
    Switch ($PSCmdlet.ParameterSetName)
    {
      'General'
      {
        $uri += "/api/searchpasswords/?Search=$([System.Web.HttpUtility]::UrlEncode($Search))&ExcludePassword=true"
      }
      'PasswordID'
      {
        $uri += "/api/passwords/$($PasswordID)?ExcludePassword=true"
      }
      'Specific'
      {
        $BuildURL = '?'
        If ($Title) {          $BuildURL += "Title=$([System.Web.HttpUtility]::UrlEncode($Title))&" }
        If ($UserName) {       $BuildURL += "UserName=$([System.Web.HttpUtility]::UrlEncode($UserName))&" }
        If ($HostName) {       $BuildURL += "HostName=$([System.Web.HttpUtility]::UrlEncode($HostName))&" }
        If ($Domain) {         $BuildURL += "Domain=$([System.Web.HttpUtility]::UrlEncode($Domain))&" }
        If ($AccountType) {    $BuildURL += "AccountType=$([System.Web.HttpUtility]::UrlEncode($AccountType))&" }
        If ($Description) {    $BuildURL += "Description=$([System.Web.HttpUtility]::UrlEncode($Description))&" }
        If ($Notes) {          $BuildURL += "Notes=$([System.Web.HttpUtility]::UrlEncode($Notes))&" }
        If ($URL) {            $BuildURL += "URL=$([System.Web.HttpUtility]::UrlEncode($URL))&" }
        If ($SiteID) {         $BuildURL += "SiteID=$([System.Web.HttpUtility]::UrlEncode($SiteID))&" }
        If ($SiteLocation) {   $BuildURL += "SiteLocation=$([System.Web.HttpUtility]::UrlEncode($SiteLocation))&" }
        If ($GenericField1) {  $BuildURL += "GenericField1=$([System.Web.HttpUtility]::UrlEncode($GenericField1))&" }
        If ($GenericField2) {  $BuildURL += "GenericField2=$([System.Web.HttpUtility]::UrlEncode($GenericField2))&" }
        If ($GenericField3) {  $BuildURL += "GenericField3=$([System.Web.HttpUtility]::UrlEncode($GenericField3))&" }
        If ($GenericField4) {  $BuildURL += "GenericField4=$([System.Web.HttpUtility]::UrlEncode($GenericField4))&" }
        If ($GenericField5) {  $BuildURL += "GenericField5=$([System.Web.HttpUtility]::UrlEncode($GenericField5))&" }
        If ($GenericField6) {  $BuildURL += "GenericField6=$([System.Web.HttpUtility]::UrlEncode($GenericField6))&" }
        If ($GenericField7) {  $BuildURL += "GenericField7=$([System.Web.HttpUtility]::UrlEncode($GenericField7))&" }
        If ($GenericField8) {  $BuildURL += "GenericField8=$([System.Web.HttpUtility]::UrlEncode($GenericField8))&" }
        If ($GenericField9) {  $BuildURL += "GenericField9=$([System.Web.HttpUtility]::UrlEncode($GenericField9))&" }
        If ($GenericField10) { $BuildURL += "GenericField10=$([System.Web.HttpUtility]::UrlEncode($GenericField10))&" }
        
        $BuildURL = $BuildURL -Replace ".$"
        
        $uri += "/api/searchpasswords/$($BuildURL)&ExcludePassword=true"
      }
    }
    
    Try
    {
      $tempobj = Get-PasswordStateResource -URI $uri -ErrorAction stop
    }
    Catch
    {
      Throw $_.Exception
    }

    Foreach ($item in $tempobj)
    {
      [PasswordResult]$obj = Get-PasswordStateResource -URI "/api/passwords/$($item.PasswordID)" -ExtraParams @{"Headers" = $headerreason} -Method GET
      $output += $obj
    }
  }

  End
  {
    If ($output.count -gt 0)
    {
      Return $output
    }
    Else
    {
      Throw "No Password found"
    }
  }
}
