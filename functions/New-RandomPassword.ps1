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

.EXAMPLE
    PS C:\> New-RandomPassword

.EXAMPLE
    New-RandomPassword -length 60 -includenumbers -includeuppercase -includelowercase -includespecialcharacters -includebrackets -Quantity 1

.INPUTS
    PasswordGeneratorID - Optional parameter if you want to generate a more or less secure password.
.OUTPUTS
    A string value of the generated password.
.NOTES
    Daryl Newsholme 2019
#>
function New-RandomPassword {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
    )]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0)][int32]$length = 12,
        [parameter(ValueFromPipelineByPropertyName, Position = 1)][switch]$includebrackets,
        [parameter(ValueFromPipelineByPropertyName, Position = 2)][switch]$includespecialcharacters,
        [parameter(ValueFromPipelineByPropertyName, Position = 3)][switch]$includenumbers,
        [parameter(ValueFromPipelineByPropertyName, Position = 4)][switch]$includelowercase,
        [parameter(ValueFromPipelineByPropertyName, Position = 5)][switch]$includeuppercase,
        [parameter(ValueFromPipelineByPropertyName, Position = 6)][string]$excludedcharacters,
        [parameter(ValueFromPipelineByPropertyName, Position = 7)][int32]$Quantity = 1
    )

    begin {
        & $(Get-NativePath -PathAsStringArray "$PSScriptroot","PasswordstateClass.ps1")
    }

    process {
        if ($PSCmdlet.ShouldProcess("")) {
            if ($PSBoundParameters.Count -lt 1) {
                $output = Get-PasswordStateResource -uri "/api/generatepassword"
            }
            Else {
                if (!$excludedcharacters) {
                    $excludedcharacters = [uri]::EscapeDataString(" *")
                }
                else {
                    $excludedcharacters = [uri]::EscapeDataString(" $excludedcharacters")
                }
                if (
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
                Write-Verbose "[$(Get-Date -format G)] [GET] $uri"
                Get-PasswordStateResource -uri $uri
            }
        }

    }

    end {
        return $output
    }
}