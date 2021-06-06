push-Location $PSScriptRoot\..\tests\functions
Invoke-Pester -Output Detailed
Pop-Location