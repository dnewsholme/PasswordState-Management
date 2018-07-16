param(
    $repotype = "local",
    $reponame,
    $sourcelocation,
    $publishlocation,
    $modulepath = "$($env:ProgramFiles)\WindowsPowershell\Modules",
    $apikey
)
$modulename = $($env:CI_PROJECT_NAME).tolower()

Remove-Item "$modulepath\$modulename" -Recurse -Force -erroraction silentlycontinue
Copy-Item ".\$modulename" -Recurse -Destination $modulepath

if ($($env:repotype) -eq "psgallery") {
    Publish-Module -Name $modulename -NuGetApiKey $($env:apikey) -Verbose
}


Else {
    Register-PSRepository -name $($env:reponame) -sourcelocation $($env:sourcelocation) -publishlocation $($env:publishlocation) -erroraction silentlycontinue
    try {
        Publish-Module -Name $modulename -Repository $env:reponame -Verbose -Force
    }
    Catch {
        throw "An error occurred publishing the module $modulename"
    }
}