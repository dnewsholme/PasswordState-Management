function Remove-DiacriticsFromString {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [parameter(ValueFromPipelineByPropertyName, valueFromPipeline, Position = 0, Mandatory = $true)]$InputString
    )

    Begin { }
    Process {
        if ($PSCmdlet.ShouldProcess("InputString:$($InputString)")) {
            # First convert german umlauts and other latin/non-latin diacritics to readable text (not ö to o -> ö to oe)
            $ReplaceDictionary = @{"ß" = "ss"; "à" = "a"; "á" = "a"; "â" = "a"; "ã" = "a"; "ä" = "ae"; "å" = "a"; "æ" = "ae"; "ç" = "c"; "è" = "e"; "é" = "e"; "ê" = "e"; "ë" = "e"; "ì" = "i"; "í" = "i"; "î" = "i"; "ï" = "i"; "ð" = "d"; "ñ" = "n"; "ò" = "o"; "ó" = "o"; "ô" = "o"; "õ" = "o"; "ö" = "oe"; "ø" = "o"; "ù" = "u"; "ú" = "u"; "û" = "u"; "ü" = "ue"; "ý" = "y"; "þ" = "p"; "ÿ" = "y" }

            foreach ($key in $ReplaceDictionary.Keys) {
                $InputString = $InputString -Replace ($key, $ReplaceDictionary.$key)
            }
            # Second, just to make sure some characters were not in the list, convert the full input string.
            $InputString = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($InputString))
        }
    }
    end {
        return $InputString
    }
}

