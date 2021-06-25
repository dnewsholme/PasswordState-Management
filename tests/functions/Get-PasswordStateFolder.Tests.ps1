BeforeAll {
    if (Test-Path "$([environment]::GetFolderPath('UserProfile'))/passwordstate.json") {
        Rename-Item "$([environment]::GetFolderPath('UserProfile'))/passwordstate.json" "$([environment]::GetFolderPath('UserProfile'))/stowaway_passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
    }
    Import-Module -Name "$($PSScriptRoot)/../../passwordstate-management.psd1" -Force
}
AfterAll {
    Remove-Module -Name 'passwordstate-management' -ErrorAction SilentlyContinue
    if (Test-Path "$([environment]::GetFolderPath('UserProfile'))/stowaway_passwordstate.json") {
        Rename-Item "$([environment]::GetFolderPath('UserProfile'))/stowaway_passwordstate.json" "$([environment]::GetFolderPath('UserProfile'))/passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
    }
}
Describe 'Get-PasswordstateFolder' {
    BeforeAll {
        $FunctionName = 'Get-PasswordStateFolder'
        $BaseURI = 'https://passwordstate.local'
        $APIKey = 'SuperSecretKey'
        $ProfilePath = 'TestDrive:'
        $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
        $Paramattributetype='System.Management.Automation.ParameterAttribute'
    }
    Context "Parameter Validation" -Foreach @(
        @{parametername = 'FolderName'; mandatory = 'False' }
        , @{parametername = 'Description'; mandatory = 'False' }
        , @{parametername = 'TreePath'; mandatory = 'False' }
        , @{parametername = 'SiteID'; mandatory = 'False' }
        , @{parametername = 'SiteLocation'; mandatory = 'False' }
        , @{parametername = 'PreventAuditing'; mandatory = 'False' }
    ) {
        It "Should have a parameter <Parametername>" {
            $Parametername | Should -BeIn (Get-Command -Name $FunctionName).Parameters.Keys
        }
        It 'Should have set Mandatory value to <mandatory> for parameter <parametername>' {
            $Attributes = (Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().FullName -eq $Paramattributetype}
            $Attributes.Mandatory | Should -BeExactly $mandatory
        }
    }
    Context "Unit tests with winapi profile" {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -Apikey $APIKey -path $ProfilePath | Out-Null
            . "$($PSScriptRoot)/json/enum-jsonFiles.ps1"
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchResponse'] } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchFolderNameResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?FolderName=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchDescriptionResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?Description=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchTreePathResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?TreePath=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchSiteIDResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteID=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchSiteLocationResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteLocation=[^\$]+$' } -Verifiable
        
        }
        AfterAll {
            Remove-Item -Path "$($ProfilePath)/passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
        }
        It "Should return 6 folders without parameters" {
            (Get-PasswordStateFolder).Count | Should -BeExactly 6
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Times 1 -scope Context
            }
        }
        It 'Should return <FolderCount> for parameter <parametername>' -ForEach @(
            @{parametername = 'FolderName'; testvalue = "Active Directory"; FolderCount = 1 }
            , @{parametername = 'Description'; testvalue = "Root"; FolderCount = 1 }
            , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Oracle"; FolderCount = 1 }
        ) {
            ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $FolderCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Windows Integrated' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -WindowsAuthOnly -path $ProfilePath | Out-Null
            . "$($PSScriptRoot)/json/enum-jsonFiles.ps1"
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchResponse'] } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchFolderNameResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?FolderName=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchDescriptionResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?Description=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchTreePathResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?TreePath=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchSiteIDResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteID=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchSiteLocationResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteLocation=[^\$]+$' } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$($ProfilePath)/passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
        }
        It "Should return 6 folders without parameters" {
            (Get-PasswordStateFolder).Count | Should -BeExactly 6
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Times 1 -scope Context
            }
        }
        It 'Should return <FolderCount> for parameter <parametername>' -ForEach @(
            @{parametername = 'FolderName'; testvalue = "Active Directory"; FolderCount = 1 }
            , @{parametername = 'Description'; testvalue = "Root"; FolderCount = 1 }
            , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Oracle"; FolderCount = 1 }
        ) {
            ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $FolderCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Custom Credential' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -customcredentials $TestCredential -path $ProfilePath | Out-Null
            . "$($PSScriptRoot)/json/enum-jsonFiles.ps1"
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchResponse'] } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchFolderNameResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?FolderName=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchDescriptionResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?Description=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchTreePathResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?TreePath=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchSiteIDResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteID=[^\$]+$' } -Verifiable
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['FolderSearchSiteLocationResponse'] } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteLocation=[^\$]+$' } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$($ProfilePath)/passwordstate.json" -ErrorAction SilentlyContinue -Force -Confirm:$false
        }
        It "Should return 6 folders without parameters" {
            (Get-PasswordStateFolder).Count | Should -BeExactly 6
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Times 1 -scope Context
            }
        }
        It 'Should return <FolderCount> for parameter <parametername>' -ForEach @(
            @{parametername = 'FolderName'; testvalue = "Active Directory"; FolderCount = 1 }
            , @{parametername = 'Description'; testvalue = "Root"; FolderCount = 1 }
            , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Oracle"; FolderCount = 1 }
        ) {
            ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $FolderCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
}