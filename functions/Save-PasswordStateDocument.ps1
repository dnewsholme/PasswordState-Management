function Save-PasswordStateDocument {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 1)][ValidateSet(
            "password",
            "passwordlist",
            "folder"
        )][string]$resourcetype = "password",
        [parameter(ValueFromPipelineByPropertyName, Position = 2)][int32]$DocumentID,
        [parameter(ValueFromPipelineByPropertyName, Position = 4)][string]$Path,
        [parameter(ValueFromPipelineByPropertyName, Position = 5)][string]$Reason

    )

    begin {
        $output = @()
    }

    process {
        $headerreason = @{'Reason' = "$Reason" }
        try {
            $splatparams = @{
                "uri" = "/api/document/$($resourcetype)/$documentID"
                "extraparams" = @{
                    "OutFile" = "$Path"
                    "Headers" = $headerreason
                }
                "contenttype" = 'multipart/form-data'
                "ErrorAction" = "stop"
            }
            $output += Get-PasswordStateResource @splatparams
        }
        Catch {
            $_.Exception
        }

    }

    end {
        return (Get-Item $Path)
    }
}