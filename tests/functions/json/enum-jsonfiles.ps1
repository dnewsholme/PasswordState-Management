$Global:TestJSON= @{}
foreach ($file in Get-ChildItem -Filter *.json -Recurse) {
    $Global:TestJSON[$File.BaseName] = (Get-content $file.fullname | ConvertFrom-Json)
}
