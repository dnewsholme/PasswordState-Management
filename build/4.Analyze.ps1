$analysis = @()
$files = get-childitem $psscriptroot\..\Functions\*.ps1 -recurse | Where-Object {$_.fullname -notlike "*.Tests*"}
$analysis += $files | ForEach-Object {Invoke-ScriptAnalyzer -Path $_.FullName}
if (($analysis).Count -gt 0) {
    $analysis

    Throw 'Failed PSScriptAnalyzer rules'
}
Else {
    Write-Output "All Analysis tests passed."
}