function New-PasswordStateList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password field.'
    )]
    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$Name,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][string]$description,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][int32]$CopySettingsFromPasswordListID,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][int32]$FolderID

    )

    begin {
    }
    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [pscustomobject]@{
            "PasswordList"                   = $Name
            "Description"                    = $description
            "CopySettingsFromPasswordListID" = $CopySettingsFromPasswordListID
            "NestUnderFolderID"              = $FolderID
            "LinkToTemplate" = $false
            "CopySettingsFromTemplateID" = ""
            "SiteID" = "0"
        }
        $penv = Get-PasswordStateEnvironment
        if ($penv.AuthType -eq "APIKey"){
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $penv.Apikey
        }
        if ($PSCmdlet.ShouldProcess("$Name under folder $folderid")) {
            $body = "$($body|convertto-json)"
            Write-Verbose "$body"
            $output = New-PasswordStateResource  -uri "/api/passwordlists" -body $body
        }
    }

    end {
        return $output
    }
}