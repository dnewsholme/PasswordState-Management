<#
.SYNOPSIS
    Gets all password lists from the API (Only those you have permissions to.)
.DESCRIPTION
    Gets all password lists from the API (Only those you have permissions to.)
.PARAMETER PasswordListID
    Gets the passwordlist based on ID, when omitted, gets all the passord lists
.PARAMETER SearchBy
    Indication when you want to search based on ID or Name
.PARAMETER SearchName
    The name to search
.EXAMPLE
    PS C:\> Get-PasswordStateList
.OUTPUTS
    Returns the lists including their names and IDs.
.NOTES
    Daryl Newsholme 2018
#>
function Get-PasswordStateList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password just an ID'
    )]
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0,ParameterSetName='SearchByID')][int32]$PasswordListID,
        [parameter(ValueFromPipelineByPropertyName, Position = 0,ParameterSetName='SearchBy')][ValidateSet('ID','Name')][string]$Searchby = 'ID',
        [parameter(ValueFromPipelineByPropertyName, Position = 1,ParameterSetName='SearchBy')][string]$SearchName
    )

    begin {
    }

    process {
        switch ( $Searchby )
        {
            'Name'{
                $lists = Get-PasswordStateResource -uri "/api/searchpasswordlists/?PasswordList=$SearchName"
            }
            'ID'{
                if (!$PasswordListID) {
                    $lists = Get-PasswordStateResource -uri "/api/passwordlists"
                }
                else {
                    $lists = Get-PasswordStateResource -uri "/api/passwordlists/$passwordListID"
                }
            }
        }
    }
    end {
        return $lists
    }
}