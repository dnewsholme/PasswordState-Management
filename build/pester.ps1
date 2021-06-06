push-Location $PSScriptRoot\..\tests\functions
Invoke-Pester -Output Detailed -PassThru
if (0 -ne $LASTEXITCODE) { throw 'Not all tests passed!!'}
Pop-Location