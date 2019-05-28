function Get-NativePath {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [string[]]$PathAsStringArray
    )

    $PathAsStringArray = foreach ($pathPart in $PathAsStringArray) {
        $SplitAttempt = $pathPart -split [regex]::Escape([IO.Path]::DirectorySeparatorChar)

        if ($SplitAttempt.Count -gt 1) {
            foreach ($obj in $SplitAttempt) {
                $obj
            }
        }
        else {
            $pathPart
        }
    }
    $PathAsStringArray = $PathAsStringArray -join [IO.Path]::DirectorySeparatorChar

    $PathAsStringArray

}