push-Location $PSScriptRoot\..\functions
$results = Invoke-Pester -EnableExit -PassThru -Show all -OutputFile $psscriptroot\report.xml -OutputFormat NUnitXml
& "$PSScriptRoot\nunit\msxsl.exe" "$PSScriptRoot\report.xml" "$PSScriptRoot\nunit\nunit-to-junit.xsl" -o "$PSScriptRoot\junitreport.xml"
$failed = ($results.TestResult | ? {$_.Passed -ne $true})
if ($failed) {
    $failed | Select Context, Result, Name, Describe | ft
    throw "Some rules failed."
}
Pop-Location