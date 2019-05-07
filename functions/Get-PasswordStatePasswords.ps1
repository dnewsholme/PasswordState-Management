<#
.SYNOPSIS
    Gets All PasswordStatePasswords from a list, based on ID. Use Get-PasswordStateList to search for a name and return the ID
.DESCRIPTION
    Gets All PasswordStatePasswords from a list, based on ID. Use Get-PasswordStateList to search for a name and return the ID
.EXAMPLE
    PS C:\> Get-PasswordStatePassword -PasswordListID 1
    Returns all user objects including password.
.PARAMETER PasswordListID
    An ID of a specific passwordlist resource to return.
.NOTES
    Willem R 2019
#>
function Get-PasswordStatePasswords {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'No Password is used only ID.'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUserNameAndPassWordParams', '', Justification = 'PasswordID isnt a password')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Only returns multiple')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Needed for backward compatability')]
    param (
        [Parameter(ParameterSetName='GetAllPasswordsFromList', Mandatory = $false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True, Position = 0)][int32[]]$PasswordlistID
    )

    begin {
        . "$PSScriptRoot\PasswordstateClass.ps1"
        $output = @()
    }

    process {
        [PasswordResult]$results = Get-PasswordStateResource -uri $("/api/passwords/" + $PasswordlistID + "?QueryAll")
        Foreach ($result in $results){
            $result.Password = [EncryptedPassword]$result.Password
            $output += $result
        }
    }

    end {
        switch ($global:PasswordStateShowPasswordsPlainText) {
            True {
                $output.DecryptPassword()
            }
        }
        Return $output
    }
}