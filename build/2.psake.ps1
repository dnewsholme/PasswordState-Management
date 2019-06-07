# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
    $projectName = $($env:CI_PROJECT_NAME).tolower()
    Set-BuildEnvironment
    "ProjectName is $projectName"
    $env:BHProjectName = $projectName
    $ProjectRoot = $ENV:BHProjectPath -replace ("/", "\")
    if (-not $ProjectRoot) {
        $ProjectRoot = Split-Path $PSScriptRoot -Parent
    }
    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $lines = '----------------------------------------------------------------------'
    $outputdir = "$projectroot\"
    "Output dir is $outputdir"
    $Verbose = @{}
    if ($ENV:BHCommitMessage -match "!verbose") {
        $Verbose = @{Verbose = $True}
    }
    $excludedrules = "PSAvoidUsingPlainTextForPassword", "PSUseShouldProcessForStateChangingFunctions", "PSAvoidUsingConvertToSecureStringWithPlainText", "PSAvoidUsingUserNameAndPassWordParams", "PSUseSingularNouns"
    $tags = 'PasswordState', 'Password', 'Management','PSEdition_Desktop','PSEdition_Core','Windows','Linux','MacOS'
    $Guid = '752125dd-c0e4-4f87-bad9-dd7dc9b45b58'
}


Task default -Depends Build

Task Init {
    $lines
    Set-Location $ProjectRoot
    "Build System Details:"
    Get-Item ENV:BH*
    "`n"
    Get-BuildEnvironment
}



Task Clean -Depends Init {
    $lines
    "`nCleaning Old Builds."

    "`n"
    try {
        Remove-Module $Projectname -Verbose -ErrorAction SilentlyContinue
        Remove-Item "$projectroot\$($Projectname)" -Recurse -Force -ErrorAction SilentlyContinue
    }
    Catch {}
}

Task Build -Depends Clean {
    $lines
    $Functions = (Get-ChildItem $ProjectRoot\functions\*.ps1) | Where-Object {$_.Name -notlike "*.Tests.ps1"}
    Write-Verbose "ProjectName is $($Projectname)"
    $commitmsg = (Get-BuildEnvironment).CommitMessage
    $commitmsg
    try {
        $global:buildversion = $(((Find-Module -Name $($Projectname) -ErrorAction Stop))| Sort-Object version |Select-Object -Last 1 ).Version
        switch -Wildcard ($commitmsg){
            "*major*"{
                $global:buildversion = $global:buildversion | Step-Version -By Major
            }
            "*minor*"{
                $global:buildversion =  $global:buildversion | Step-Version -By Minor
            }
            "*nobuild*"{
                exit 0
            }
            Default {
                $global:buildversion = $global:buildversion | Step-Version -By Patch
            }
        }
        $global:buildversion
    }
    Catch {
        $v = ([Version]::new(0, 0, 1))
        $global:buildversion = $v
    }
    #Should just use plaster...
    $ModuleName = "$($Projectname)"
    $ModPath = "$outputdir$modulename"
    $exportedfunctions = $Functions.Name -replace ".ps1"
    $exportedfunctions | ForEach-Object {Write-Verbose $($_) -Verbose}
    $PSD1Path = Join-Path -path $ModPath -ChildPath "$($Projectname).psd1"
    $Null = mkdir $ModPath
    $functions | foreach-object {Copy-Item -Path $_.FullName -Destination $ModPath -Verbose}
    Copy-Item "$($projectroot)\build\$($Projectname).psm1" $ModPath -Verbose
    New-ModuleManifest -Guid $Guid `
        -Path $PSD1Path `
        -Author 'Daryl Newsholme' `
        -RootModule "$($Projectname).psm1" `
        -ModuleVersion "$global:buildversion" `
        -Description "Powershell Module for managing Password State" `
        -FunctionsToExport $exportedfunctions `
        -ProjectUri "https://github.com/dnewsholme/PasswordState-Management" `
        -IconUri "https://github.com/dnewsholme/PasswordState-Management/blob/master/images/passwordstate.png?raw=true" `
        -HelpInfoUri "https://github.com/dnewsholme/PasswordState-Management/blob/master/readme.md" `
        -ReleaseNotes "$((Get-Content $projectroot\Changelog.md -raw | select-string -pattern '(\+[\sA-z0-9\.]+[\sA-z0-9\.]+){1,}(?=\n)').Matches.Value)" `
        -Tags $tags

    $PSD1 = Get-Content $PSD1Path -Raw
    $PSD1 = $PSD1 -replace 'RootModule', 'ModuleToProcess'
    # We have a module, BuildHelpers will see it
    Set-BuildEnvironment -Force

    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunctions -FunctionsToExport $exportedfunctions
    Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $global:buildversion
    if (-not $ENV:BHPSModulePath) {
        Get-Item ENV:BH*
        Throw 'BuildHelpers fail!'
    }
    # Check build
    foreach ($i in $Functions) {
        try {
            Test-Path $ProjectRoot\$ModuleName\$($i.Name)
        }
        catch {
            throw "$($i.Name) missing from build location"
        }
    }
    $global:modpath = $ModPath
}
task Analyze -Depends Build {
    $analysis = Invoke-ScriptAnalyzer -Path $global:modpath\*.ps1 -ExcludeRule $excludedrules -Verbose:$false
    $errors = $analysis | Where-Object {$_.Severity -eq 'Error'}
    $warnings = $analysis | Where-Object {$_.Severity -eq 'Warning'}

    if (($errors.Count -eq 0) -and ($warnings.Count -eq 0)) {
        '    PSScriptAnalyzer passed without errors or warnings'
    }

    if (@($errors).Count -gt 0) {
        Write-Error -Message 'One or more Script Analyzer errors were found. Build cannot continue!'
        $errors | Format-Table
    }

    if (@($warnings).Count -gt 0) {
        Write-Warning -Message 'One or more Script Analyzer warnings were found. These should be corrected.'
        $warnings | Format-Table
    }
} -description 'Run PSScriptAnalyzer'