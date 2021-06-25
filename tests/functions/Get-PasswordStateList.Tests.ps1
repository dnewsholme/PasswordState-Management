BeforeAll {
    if (Test-Path "$([environment]::GetFolderPath('UserProfile'))\passwordstate.json") {
        Rename-Item "$([environment]::GetFolderPath('UserProfile'))\passwordstate.json" "$([environment]::GetFolderPath('UserProfile'))\stowaway_passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
    }
    Import-Module -Name "$($PSScriptRoot)\..\..\passwordstate-management.psd1" -Force
}
AfterAll {
    Remove-Module -Name 'passwordstate-management' -ErrorAction SilentlyContinue
    if (Test-Path "$([environment]::GetFolderPath('UserProfile'))\stowaway_passwordstate.json") {
        Rename-Item "$([environment]::GetFolderPath('UserProfile'))\stowaway_passwordstate.json" "$([environment]::GetFolderPath('UserProfile'))\passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
    }
}
Describe "Get-PasswordstateList" {
    BeforeAll {
        $FunctionName = 'Get-PasswordStateList'
        $BaseURI = 'https://passwordstate.local'
        $APIKey = 'SuperSecretKey'
        $ProfilePath = 'TestDrive:'
        $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
        $Paramattributetype='System.Management.Automation.ParameterAttribute'
        . "$($PSScriptRoot)\json\enum-jsonfiles.ps1"
    }
    Context 'Parameter Validation' -Foreach @(
        @{parametername = 'PasswordListID'; mandatory = 'False'; ParameterSetName = "ID" }
        , @{parametername = 'PasswordList'; mandatory = 'False'; ParameterSetName = "Specific" }
        , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
        , @{parametername = 'TreePath'; mandatory = 'False'; ParameterSetName = "Specific" }
        , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
        , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
        , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
    ) {
        It 'should verify if parameter "<parametername>" is present' {
            (Get-Command -Name $FunctionName).Parameters[$parametername] | Should -Not -BeNullOrEmpty
        }
        It 'should verify if mandatory for parameter "<parametername>" is set to "<mandatory>"' {
            "$(((Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().fullname -eq $Paramattributetype}).Mandatory)" | Should -be $mandatory
        }
        It 'should verify if parameter "<parametername>" is part of "<parametersetname>" ParameterSetName' {
            "$(((Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().fullname -eq $Paramattributetype}).ParameterSetName)" | Should -be $ParameterSetName
        }
    }
    Context 'Unit tests with API key' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -Apikey $APIKey -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListResponse'] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchPasswordListResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?PasswordList=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchDescriptionResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?Description=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchTreePathResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?TreePath=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchSiteIDResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteID=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchSiteLocationResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteLocation=[^\&]+$' }
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return <ListCount> for parameter <parametername>' -ForEach @(
            @{parametername = ''; testvalue = ""; ListCount = 8 }
            , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
            , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
            , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
            , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }

        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            } else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have <ListCount> results with "<parametername>" matching "<testvalue>"' -ForEach @(
            @{parametername = ''; testvalue = ""; ListCount = 8 }
            , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
            , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
            , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
            , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }
        ) {
            $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Windows Authentication' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -WindowsAuthOnly -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListResponse'] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchPasswordListResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?PasswordList=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchDescriptionResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?Description=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchTreePathResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?TreePath=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchSiteIDResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteID=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchSiteLocationResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteLocation=[^\&]+$' }
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return <ListCount> for parameter <parametername>' -ForEach @(
            @{parametername = ''; testvalue = ""; ListCount = 8 }
            , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
            , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
            , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
            , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }

        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            } else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have <ListCount> results with "<parametername>" matching "<testvalue>"' -ForEach @(
            @{parametername = ''; testvalue = ""; ListCount = 8 }
            , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
            , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
            , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
            , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }
        ) {
            $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Custom Credentials' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -customcredentials $TestCredential -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListResponse'] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchPasswordListResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?PasswordList=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchDescriptionResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?Description=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchTreePathResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?TreePath=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchSiteIDResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteID=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['ListSearchSiteLocationResponse'] } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteLocation=[^\&]+$' }
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return <ListCount> for parameter <parametername>' -ForEach @(
            @{parametername = ''; testvalue = ""; ListCount = 8 }
            , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
            , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
            , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
            , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }

        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            } else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have <ListCount> results with "<parametername>" matching "<testvalue>"' -ForEach @(
            @{parametername = ''; testvalue = ""; ListCount = 8 }
            , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
            , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
            , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
            , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }
        ) {
            $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
}