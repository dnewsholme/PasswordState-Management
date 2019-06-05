<#
    .SYNOPSIS
    Generates a random Password from the Password state generator API
    .DESCRIPTION
    Generates a random Password from the Password state generator API

    .PARAMETER length
    Length for the generated password
    .PARAMETER includebrackets
    If brackets should be included such as {}()
    .PARAMETER includespecialcharacters
    If special characters such as ^_> should be included.
    .PARAMETER includenumbers
    If numbers should be included.
    .PARAMETER includelowercase
    If lowercase characters should be included.
    .PARAMETER includeuppercase
    If uppercase should be included.
    .PARAMETER Quantity
    The quantity of passwords to generate.

    .PARAMETER PolicyID
    ID for an existing Password Generator ID

    .EXAMPLE
    PS C:\> New-RandomPassword

    .EXAMPLE
    PS C:\> New-RandomPassword -length 60 -includenumbers -includeuppercase -includelowercase -includespecialcharacters -includebrackets -Quantity 1

    .EXAMPLE
    PS C:\> New-RandomPassword -PolicyID 2

    .INPUTS
    PasswordGeneratorID - Optional parameter if you want to generate a more or less secure password.
    .OUTPUTS
    A string value of the generated password.
    .NOTES
    Daryl Newsholme 2019
#>
Function New-RandomPassword {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
      'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
  )]
  [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'General')]
  Param (
    [parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 0)][int32]$length = 12,
    [parameter(ParameterSetName = 'PolicyID', Mandatory = $true, ValueFromPipelineByPropertyName, Position = 0)][ValidateNotNullOrEmpty()][int32]$PolicyID,
    [parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 1)][switch]$includebrackets,
    [parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 2)][switch]$includespecialcharacters,
    [parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 3)][switch]$includenumbers,
    [parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 4)][switch]$includelowercase,
    [parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 5)][switch]$includeuppercase,
    [parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 6)][string]$excludedcharacters,
    [parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 7)][int32]$Quantity = 1
  )

  Begin {
    . "$(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordStateClass.ps1")"
  }

  Process {
    Switch ($PSCmdlet.ParameterSetName) {
      # Specify every part of the rule with params
      'General' {
        If ($PSCmdlet.ShouldProcess("")) {
          If ($PSBoundParameters.Count -lt 1) {
            $uri = "/api/generatepassword"
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
        $uri = "/api/generatepassword/?PasswordGeneratorID=$PolicyID"
      }
    }
    Write-Verbose "[$(Get-Date -format G)] [GET] $uri"
    Get-PasswordStateResource -uri $uri
  }
}
