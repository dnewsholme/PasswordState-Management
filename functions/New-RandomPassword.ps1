Function New-RandomPassword {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
      'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
  )]
  [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'General')]
  Param (
    [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 0)][int32]$length = 12,
    [Parameter(ParameterSetName = 'PolicyID', Mandatory = $true, ValueFromPipelineByPropertyName, Position = 0)][int32]$PolicyID,
    [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 1)][switch]$includebrackets,
    [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 2)][switch]$includespecialcharacters,
    [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 3)][switch]$includenumbers,
    [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 4)][switch]$includelowercase,
    [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 5)][switch]$includeuppercase,
    [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 6)][string]$excludedcharacters,
    [Parameter(ValueFromPipelineByPropertyName)][int32]$Quantity = 1
  )

  Process {
    Switch ($PSCmdlet.ParameterSetName) {
      # Specify every part of the rule with params
      'General' {
        If ($PSCmdlet.ShouldProcess("")) {
          If ($PSBoundParameters.Count -eq 0 -or ($PSBoundParameters.Count -eq 1 -and $PSBoundParameters.ContainsKey('Quantity'))) {
            $uri = "/api/generatepassword/?Qty=$Quantity"
          }
          Else {
            If (!$excludedcharacters) {
              $excludedcharacters = [uri]::EscapeDataString(" *")
            }
            Else {
              $excludedcharacters = [uri]::EscapeDataString(" $excludedcharacters")
            }
            If (
              $length -and
              $includelowercase -eq $false -and
              $includeuppercase -eq $false -and
              $includenumbers -eq $false -and
              $includebrackets -eq $false -and
              $includespecialcharacters -eq $false
            ) {
              $includelowercase = $true
              $includenumbers = $true
              $includeuppercase = $true
            }
            [string]$includebrackets = ([string]$includebrackets).ToLower()
            [string]$includelowercase = ([string]$includelowercase).ToLower()
            [string]$includeuppercase = ([string]$includeuppercase).ToLower()
            [string]$includespecialcharacters = ([string]$includespecialcharacters).ToLower()
            [string]$includenumbers = ([string]$includenumbers).ToLower()

            $uri = "/api/generatepassword/?IncludeAlphaSpecial=true&IncludeWordPhrases=false&minLength=$length&maxLength=$length&lowerCaseChars=$includelowercase&upperCaseChars=$includeuppercase&numericChars=$includenumbers&higherAlphaRatio=true&ambiguousChars=true&specialChars=$includespecialcharacters&specialCharsText=!$%+-_=^&bracketChars=$includebrackets&bracketCharsText={}()&NumberOfWords=0&MaxWordLength=0&PrefixAppend=P&SeparateWords=N&ExcludeChars=$excludedcharacters&GeneratePattern=false&Pattern=null&Qty=$quantity"
          }
        }
      }
      # Generate a password using an existing Password Generator ID
      'PolicyID' {
        $uri = "/api/generatepassword/?PasswordGeneratorID=$PolicyID&Qty=$Quantity"
      }
    }
    Write-Verbose "[$(Get-Date -format G)] [GET] $uri"
    Get-PasswordStateResource -uri $uri
  }
}
