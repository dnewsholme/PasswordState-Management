function Test-PasswordPwned {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Used for output')]
    param (
        [parameter(ValueFromPipeline, Mandatory = $true, Position = 0)][Alias("Password")][String]$Value
    )
    begin {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        class pwnpasswd {
            [string]$password
            [string]$hash
            [int32]$CompromisedCount

        }
    }

    process {
        $hash = (Get-StringHash -String $Value -HashName SHA1).toupper()
        $5charhash = $hash.substring(0, 5)
        $parms = @{
            uri             = "https://api.pwnedpasswords.com/range/$5charhash"
            method          = "GET"
            usebasicparsing = $true
        }

        $results = Invoke-RestMethod @parms
        $hashsuffix = $hash.replace("$5charhash", "")
        $results | where-object {$_ -like "$($hashsuffix)*"}
        # Create array of results
        $resultsarr = ($results | select-string -pattern "([A-Z0-9]+)(\:[0-9]+)" -AllMatches).Matches.Value
        $compromised = $resultsarr | Where-Object {$_ -like "$($hashsuffix):*"}
        # Create output

        $compromised | ForEach-Object {
            $output = [pwnpasswd]@{
                password         = $Value
                hash             = $hash
                CompromisedCount = ($compromised | Select-String -Pattern "(?<=\:)[0-9]+").Matches.Value
            }
        }
    }

    end {
        return $output
    }
}