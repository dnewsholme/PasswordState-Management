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
    #Get-BuildEnvironment
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
    $Functions = (Get-ChildItem $ProjectRoot\functions\*.ps1)
    Write-Verbose "ProjectName is $($Projectname)"
    $commitmsg = $ENV:BHCommitMessage
    try {
        $global:buildversion = $(((Find-Module -Name $($Projectname) -repository psgallery -ErrorAction Stop))| Sort-Object version |Select-Object -Last 1 ).Version
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
    $PSD1Path = Join-Path -path $ModPath -ChildPath "$($Projectname).psd1"
    $Null = mkdir $ModPath
    Copy-Item "$($projectroot)\$($Projectname).psm1" $ModPath -Verbose
    Copy-Item "$($projectroot)\docs\" $modpath -Recurse -Verbose
    Copy-Item "$($projectroot)\en-us\" $modpath -Recurse -Verbose
    Copy-Item "$($projectroot)\internal\" $modpath -Recurse -Verbose
    Copy-Item "$($projectroot)\functions\" $modpath -Recurse -Verbose
    Copy-Item "$($projectroot)\bin\" $modpath -Recurse -Verbose

    New-ModuleManifest -Guid $Guid `
        -Path $PSD1Path `
        -Author 'Daryl Newsholme' `
        -ModuleToProcess "$($Projectname).psm1" `
        -ModuleVersion "$global:buildversion" `
        -Description "Powershell Module for managing Password State" `
        -FunctionsToExport $($Functions.Name -replace ".ps1") `
        -AliasesToExport "*" `
        -RequiredModules "PSFramework" `
        -ProjectUri "https://github.com/dnewsholme/PasswordState-Management" `
        -IconUri "https://github.com/dnewsholme/PasswordState-Management/blob/master/images/passwordstate.png?raw=true" `
        -HelpInfoUri "https://github.com/dnewsholme/PasswordState-Management/blob/master/readme.md" `
        -ReleaseNotes "$((Get-Content $projectroot\Changelog.md -raw | select-string -pattern '(\+[\sA-z0-9\.]+[\sA-z0-9\.]+){1,}(?=\n)').Matches.Value)" `
        -Tags $tags

    # We have a module, BuildHelpers will see it
    #Set-BuildEnvironment -Force
    $global:modpath = $ModPath
}
