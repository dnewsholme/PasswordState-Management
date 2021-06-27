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
Describe 'Get-PasswordstateHost' {
    BeforeAll {
        $FunctionName = 'Get-PasswordStateHost'
        $BaseURI = 'https://passwordstate.local'
        $APIKey = 'SuperSecretKey'
        $ProfilePath = 'TestDrive:'
        $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
        $Paramattributetype='System.Management.Automation.ParameterAttribute'
        . "$($PSScriptRoot)\json\enum-jsonfiles.ps1"
    }
    Context 'Parameter Validation' -Foreach @(
        @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
        , @{parametername = 'HostType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
        , @{parametername = 'OperatingSystem'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
        , @{parametername = 'DatabaseServerType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
        , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
        , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
        , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
    ) {
        It 'should verify if parameter "<parametername>" is present' {
            (Get-Command -Name $FunctionName).Parameters[$parametername] | Should -Not -BeNullOrEmpty
        }
        It 'should verify if mandatory for parameter "<parametername>" is set to "<mandatory>"' {
            "$(((Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().fullname -eq $Paramattributetype}).Mandatory)" | Should -be $mandatory
        }
    }
    Context 'Unit tests with apikey' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -Apikey $APIKey -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearch'] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchHostName'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { throw "oepsie" } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=NonExistentHost$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchHostType'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostType=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchOperatingsystem'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?Operatingsystem=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchDatabaseServerType'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?DatabaseServerType=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchSiteID'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteID=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchSiteLocation'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteLocation=[^\&]+$' }
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return 6 hosts when no parameters are used' {
            (Get-PasswordStateHost).Count | Should -BeExactly 6
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ResultCount> host(s) when using parameter <parametername>' -Foreach @(
            , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
            , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
            , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
            , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
            , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
        ) {
            ((Invoke-Expression -Command "$($FunctionName) -$($parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $ResultCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>"' -Foreach @(
            , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
            , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
            , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
            , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
            , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
        ) {
            $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            foreach ($ReturnValue in $TestValues) {
                $ReturnValue."$($ParameterName)" | Should -MatchExactly $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should throw when Passwordstate returns an error' {
            { Invoke-Expression -Command "$($FunctionName) -HostName 'NonExistentHost'" } | Should -Throw
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Windows Authentication' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -WindowsAuthOnly -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearch'] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchHostName'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { throw "oepsie" } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=NonExistentHost$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchHostType'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostType=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchOperatingsystem'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?Operatingsystem=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchDatabaseServerType'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?DatabaseServerType=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchSiteID'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteID=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchSiteLocation'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteLocation=[^\&]+$' }
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return 6 hosts when no parameters are used' {
            (Get-PasswordStateHost).Count | Should -BeExactly 6
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }

        It 'Should return <ResultCount> host(s) when using parameter <parametername>' -Foreach @(
            , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
            , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
            , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
            , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
            , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
        ) {
            ((Invoke-Expression -Command "$($FunctionName) -$($parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $ResultCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>"' -Foreach @(
            , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
            , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
            , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
            , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
            , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
        ) {
            $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            foreach ($ReturnValue in $TestValues) {
                $ReturnValue."$($ParameterName)" | Should -MatchExactly $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should throw when Passwordstate returns an error' {
            { Invoke-Expression -Command "$($FunctionName) -HostName 'NonExistentHost'" } | Should -Throw
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Custom Credentials' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -customcredentials $TestCredential -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearch'] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchHostName'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { throw "oepsie" } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=NonExistentHost$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchHostType'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostType=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchOperatingsystem'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?Operatingsystem=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchDatabaseServerType'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?DatabaseServerType=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchSiteID'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteID=[^\&]+$' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON['HostSearchSiteLocation'] } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteLocation=[^\&]+$' }
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return 6 hosts when no parameters are used' {
            (Get-PasswordStateHost).Count | Should -BeExactly 6
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }

        It 'Should return <ResultCount> host(s) when using parameter <parametername>' -Foreach @(
            , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
            , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
            , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
            , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
            , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
        ) {
            ((Invoke-Expression -Command "$($FunctionName) -$($parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $ResultCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>"' -Foreach @(
            , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
            , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
            , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
            , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
            , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
            , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
        ) {
            $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            foreach ($ReturnValue in $TestValues) {
                $ReturnValue."$($ParameterName)" | Should -MatchExactly $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should throw when Passwordstate returns an error' {
            { Invoke-Expression -Command "$($FunctionName) -HostName 'NonExistentHost'" } | Should -Throw
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
}