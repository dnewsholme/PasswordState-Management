function New-PasswordStateDocument {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Alias("PasswordId")][parameter(ValueFromPipelineByPropertyName, Position = 0)][int32]$ID,
        [parameter(ValueFromPipelineByPropertyName, Position = 1)][ValidateSet(
            "password",
            "passwordlist",
            "folder"
        )][string]$resourcetype = "password",
        [parameter(ValueFromPipelineByPropertyName, Position = 2)][string]$DocumentName,
        [parameter(ValueFromPipelineByPropertyName, Position = 3)][string]$DocumentDescription = $null,
        [parameter(ValueFromPipelineByPropertyName, Position = 4)][string]$Path
    )

    begin {
        $output = @()
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess($path, "upload $DocumentName on $resourcetype with id $ID")) {
                $output += New-PasswordStateResource `
                    -uri "/api/document/$($resourcetype)/$($ID)?DocumentName=$($documentname)&DocumentDescription=$($documentdescription)" `
                    -extraparams @{"InFile" = "$Path"} `
                    -contenttype 'multipart/form-data' `
                    -ErrorAction stop
            }
        }
        Catch {
            $_.Exception
        }

    }

    end {
        return $output
    }
}