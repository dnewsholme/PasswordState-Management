<#
    .SYNOPSIS
    Convert a password result to a PSCredential.

    .DESCRIPTION
    Verify the input object as a PasswordResult and convert the object to a PSCredential.

    .EXAMPLE
    PS C:\> ConvertTo-PasswordStateCredential -PasswordResult (Find-PasswordStatePassword '"testuser"')
    Returns the test user object including password as a PSCredential object.
    .EXAMPLE
    PS C:\> Find-PasswordStatePassword "testuser" | ConvertTo-PasswordStateCredential
    Returns the test user object including password as a PSCredential object.

    .PARAMETER PasswordResult
    A PasswordResult object returned by the Find-PasswordStatePassword function

    .OUTPUTS
    Returns a PSCredential object.

    .NOTES
    2019 - Jarno Colombeen
#>
Function ConvertTo-PasswordStateCredential {
    Param
    (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)][ValidateNotNullOrEmpty()][Object]$PasswordResult
    )

    Process {
      If ($PasswordResult.GetType().Name -eq 'PasswordResult') {
        $User = ''
        $Password = $null
        
        If (-not ([string]::IsNullOrWhiteSpace($PasswordResult.Domain))) {
          $User += "$($PasswordResult.Domain)\"
        }
        
        $User += $PasswordResult.UserName
        $Password = $PasswordResult.Password.Password
        
        Try {
          New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User,$Password
        } Catch {
          $_
        }
      }
    }
}