push-Location $PSScriptRoot\..\tests\functions
Invoke-Pester -Output Detailed -PassThru
Pop-Location