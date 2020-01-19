function Save-PasswordStateDocument {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 1)][ValidateSet(
            "password",
            "passwordlist",
            "folder"
        )][string]$resourcetype = "password",
        [parameter(ValueFromPipelineByPropertyName, Position = 2)][int32]$DocumentID,
        [parameter(ValueFromPipelineByPropertyName, Position = 4)][string]$Path
    )

    begin {
        $output = @()
    }

    process {
        try {
            $output += Get-PasswordStateResource `
                -uri "/api/document/$($resourcetype)/$($ID)/$documentID" `
                -extraparams @{"OutFile" = "$Path"} `
                -contenttype 'multipart/form-data' `
                -ErrorAction stop
        }
        Catch {
            $_.Exception
        }

    }

    end {
        return (Get-Item $Path)
    }
}