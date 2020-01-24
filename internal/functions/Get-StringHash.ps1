<#
.SYNOPSIS
Returns a hash of a string value

.DESCRIPTION
Returns a hash of a string value

.PARAMETER String
String value to be converted to a hash.

.PARAMETER HashName
Hash type to be generated. Valid values are "MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512"

.EXAMPLE
Get-StringHash -string "qwerty" -hashname SHA1
This command returns the sha-1 hash 'b1b3773a05c0ed0176787a4f1574ff0075f7521e' for the string 'querty'

.OUTPUTS
b1b3773a05c0ed0176787a4f1574ff0075f7521e

.NOTES
Daryl Newsholme 2018
#>
Function Get-StringHash {
    [cmdletbinding()]
    [OutputType([String])]
    param(
        [parameter(ValueFromPipeline, Mandatory = $true, Position = 0)][String]$String,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true, Position = 1)]
        [ValidateSet("MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512")][String]$HashName
    )
    begin {

    }
    Process {
        $StringBuilder = New-Object System.Text.StringBuilder
        [System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))| foreach-object {
            [Void]$StringBuilder.Append($_.ToString("x2"))
        }
        $output = $StringBuilder.ToString()
    }
    end {
        return $output
    }
}
