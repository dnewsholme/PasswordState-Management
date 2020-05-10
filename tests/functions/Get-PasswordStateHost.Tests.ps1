Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateHost'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $BadHostName = 'NonExistentHost'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'HostType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'OperatingSystem'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'DatabaseServerType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
                , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
                , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
                , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
                , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
            )

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearch']
            }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostName']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=[^\&]+$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                throw "oepsie"
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=NonExistentHost$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostType=[^\&]+$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchOperatingsystem']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?Operatingsystem=[^\&]+$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchDatabaseServerType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?DatabaseServerType=[^\&]+$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteID']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteID=[^\&]+$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteLocation']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteLocation=[^\&]+$' }
        }
        Context 'Parameter Validation' {
            It 'should verify if parameter "<parametername>" is present' -TestCases $ParameterSetCases {
                param($parametername)
                (Get-Command -Name $FunctionName).Parameters[$parametername] | Should -Not -BeNullOrEmpty
            }
            It 'should verify if mandatory for parameter "<parametername>" is set to "<mandatory>"' -TestCases $ParameterSetCases {
                param($parametername, $mandatory)
                "$(((Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().fullname -eq 'System.Management.Automation.ParameterAttribute'}).Mandatory)" | Should -be $mandatory
            }
        } } }
Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateHost'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $BadHostName = 'NonExistentHost'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'HostType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'OperatingSystem'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'DatabaseServerType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
                , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
                , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
                , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
                , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
            )
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearch']
            }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostName']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                throw "oepsie"
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=NonExistentHost$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostType=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchOperatingsystem']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?Operatingsystem=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchDatabaseServerType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?DatabaseServerType=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteID']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteID=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteLocation']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteLocation=[^\&]+$' }
        }
        Context 'Unit tests with existing winapi' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = ""; AuthType = "WindowsIntegrated"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 hosts when no parameters are used' {
                (Get-PasswordStateHost).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <ResultCount> host(s) when using parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $ResultCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ReturnValue in $TestValues) {
                    $ReturnValue."$($ParameterName)" | Should -MatchExactly $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should throw when Passwordstate returns an error' {
                { Invoke-Expression -Command "$($FunctionName) -HostName '$($BadHostName)'" } | Should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}

Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateHost'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $BadHostName = 'NonExistentHost'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'HostType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'OperatingSystem'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'DatabaseServerType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
                , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
                , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
                , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
                , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
            )
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearch']
            }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostName']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                throw "oepsie"
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=NonExistentHost$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostType=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchOperatingsystem']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?Operatingsystem=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchDatabaseServerType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?DatabaseServerType=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteID']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteID=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteLocation']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteLocation=[^\&]+$' }
        }
        Context 'Unit tests with existing custom credential' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = @{username = ''; password = '' }; AuthType = "WindowsCustom"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 hosts when no parameters are used' {
                (Get-PasswordStateHost).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <ResultCount> host(s) when using parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $ResultCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ReturnValue in $TestValues) {
                    $ReturnValue."$($ParameterName)" | Should -MatchExactly $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should throw when Passwordstate returns an error' {
                { Invoke-Expression -Command "$($FunctionName) -HostName '$($BadHostName)'" } | Should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}

Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateHost'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $BadHostName = 'NonExistentHost'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'HostType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'OperatingSystem'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'DatabaseServerType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
                , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
                , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
                , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
                , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
            )
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearch']
            }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostName']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                throw "oepsie"
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=NonExistentHost$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostType=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchOperatingsystem']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?Operatingsystem=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchDatabaseServerType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?DatabaseServerType=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteID']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteID=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteLocation']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteLocation=[^\&]+$' }
        }
        Context 'Unit tests with existing apiKey' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = $APIKey; AuthType = "APIKey"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 hosts when no parameters are used' {
                (Get-PasswordStateHost).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <ResultCount> host(s) when using parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $ResultCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ReturnValue in $TestValues) {
                    $ReturnValue."$($ParameterName)" | Should -MatchExactly $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should throw when Passwordstate returns an error' {
                { Invoke-Expression -Command "$($FunctionName) -HostName '$($BadHostName)'" } | Should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}

Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateHost'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $BadHostName = 'NonExistentHost'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'HostType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'OperatingSystem'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'DatabaseServerType'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                , @{parametername = 'HostName'; testvalue = "my.local.host"; ResultCount = 1 }
                , @{parametername = 'HostType'; testvalue = "Windows"; ResultCount = 2 }
                , @{parametername = 'Operatingsystem'; testvalue = "Windows Server 2012"; ResultCount = 4 }
                , @{parametername = 'DatabaseServerType'; testvalue = "mssql"; ResultCount = 5 }
                , @{parametername = 'SiteID'; testvalue = "0"; ResultCount = 6 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ResultCount = 6 }
            )
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearch']
            }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostName']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                throw "oepsie"
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostName=NonExistentHost$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchHostType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?HostType=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchOperatingsystem']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?Operatingsystem=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchDatabaseServerType']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?DatabaseServerType=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteID']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteID=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['HostSearchSiteLocation']
            } -ParameterFilter { $uri -and $uri -match '\/hosts\/\?SiteLocation=[^\&]+$' }
        }
        Context 'Unit tests for winapi' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -WindowsAuthOnly
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 hosts when no parameters are used' {
                (Get-PasswordStateHost).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <ResultCount> host(s) when using parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $ResultCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ReturnValue in $TestValues) {
                    $ReturnValue."$($ParameterName)" | Should -MatchExactly $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should throw when Passwordstate returns an error' {
                { Invoke-Expression -Command "$($FunctionName) -HostName '$($BadHostName)'" } | Should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
        Context 'Unit tests for custom credential' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -customcredentials $TestCredential
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 hosts when no parameters are used' {
                (Get-PasswordStateHost).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <ResultCount> host(s) when using parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $ResultCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ReturnValue in $TestValues) {
                    $ReturnValue."$($ParameterName)" | Should -MatchExactly $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should throw when Passwordstate returns an error' {
                { Invoke-Expression -Command "$($FunctionName) -HostName '$($BadHostName)'" } | Should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
        Context 'Unit tests for apiKey' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -Apikey $APIKey
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 hosts when no parameters are used' {
                (Get-PasswordStateHost).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <ResultCount> host(s) when using parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $ResultCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ResultCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ReturnValue in $TestValues) {
                    $ReturnValue."$($ParameterName)" | Should -MatchExactly $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should throw when Passwordstate returns an error' {
                { Invoke-Expression -Command "$($FunctionName) -HostName '$($BadHostName)'" } | Should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}