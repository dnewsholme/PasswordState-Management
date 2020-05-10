Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateFolder" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateFolder'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'FolderName'; mandatory = 'False'; testvalue = "Active Directory" }
                , @{parametername = 'Description'; mandatory = 'False'; testvalue = "Root" }
                , @{parametername = 'TreePath'; mandatory = 'False'; testvalue = "\RootFolder\Oracle" }
                , @{parametername = 'SiteID'; mandatory = 'False'; testvalue = "1" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; testvalue = "0" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False' }
            )
            $ParameterValues = @(
                @{parametername = 'FolderName'; testvalue = "Active Directory"; FolderCount = 1 }
                , @{parametername = 'Description'; testvalue = "Root"; FolderCount = 1 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Oracle"; FolderCount = 1 }
            )
            $SiteValues = @(
                @{parametername = 'SiteID'; FolderCount = 6 }
                , @{parametername = 'SiteLocation'; FolderCount = 6 }
            )

            # This Mock should never be hit, it is just to prevent actual calls from being executed and get annoying results
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchResponse']
            } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchFolderNameResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?FolderName=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?Description=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?TreePath=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteID=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteLocation=[^\$]+$' } -Verifiable
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
        }
    }
}

Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateFolder" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateFolder'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'FolderName'; mandatory = 'False'; testvalue = "Active Directory" }
                , @{parametername = 'Description'; mandatory = 'False'; testvalue = "Root" }
                , @{parametername = 'TreePath'; mandatory = 'False'; testvalue = "\RootFolder\Oracle" }
                , @{parametername = 'SiteID'; mandatory = 'False'; testvalue = "1" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; testvalue = "0" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False' }
            )
            $ParameterValues = @(
                @{parametername = 'FolderName'; testvalue = "Active Directory"; FolderCount = 1 }
                , @{parametername = 'Description'; testvalue = "Root"; FolderCount = 1 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Oracle"; FolderCount = 1 }
            )
            $SiteValues = @(
                @{parametername = 'SiteID'; FolderCount = 6 }
                , @{parametername = 'SiteLocation'; FolderCount = 6 }
            )

            # This Mock should never be hit, it is just to prevent actual calls from being executed and get annoying results
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchResponse']
            } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchFolderNameResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?FolderName=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?Description=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?TreePath=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteID=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteLocation=[^\$]+$' } -Verifiable
        }
        Context 'Unit tests with existing apikey profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = $APIKey; AuthType = "APIKey"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 Folders when no parameters are used' {
                (Get-PasswordStateFolder).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <FolderCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $FolderCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
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
    Describe "Get-PasswordStateFolder" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateFolder'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'FolderName'; mandatory = 'False'; testvalue = "Active Directory" }
                , @{parametername = 'Description'; mandatory = 'False'; testvalue = "Root" }
                , @{parametername = 'TreePath'; mandatory = 'False'; testvalue = "\RootFolder\Oracle" }
                , @{parametername = 'SiteID'; mandatory = 'False'; testvalue = "1" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; testvalue = "0" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False' }
            )
            $ParameterValues = @(
                @{parametername = 'FolderName'; testvalue = "Active Directory"; FolderCount = 1 }
                , @{parametername = 'Description'; testvalue = "Root"; FolderCount = 1 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Oracle"; FolderCount = 1 }
            )
            $SiteValues = @(
                @{parametername = 'SiteID'; FolderCount = 6 }
                , @{parametername = 'SiteLocation'; FolderCount = 6 }
            )

            # This Mock should never be hit, it is just to prevent actual calls from being executed and get annoying results
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchResponse']
            } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchFolderNameResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?FolderName=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?Description=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?TreePath=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteID=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteLocation=[^\$]+$' } -Verifiable
        }
        Context 'Unit tests with existing winapi profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = ""; AuthType = "WindowsIntegrated"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 Folders when no parameters are used' {
                (Get-PasswordStateFolder).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <FolderCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $FolderCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
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
    Describe "Get-PasswordStateFolder" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateFolder'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'FolderName'; mandatory = 'False'; testvalue = "Active Directory" }
                , @{parametername = 'Description'; mandatory = 'False'; testvalue = "Root" }
                , @{parametername = 'TreePath'; mandatory = 'False'; testvalue = "\RootFolder\Oracle" }
                , @{parametername = 'SiteID'; mandatory = 'False'; testvalue = "1" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; testvalue = "0" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False' }
            )
            $ParameterValues = @(
                @{parametername = 'FolderName'; testvalue = "Active Directory"; FolderCount = 1 }
                , @{parametername = 'Description'; testvalue = "Root"; FolderCount = 1 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Oracle"; FolderCount = 1 }
            )
            $SiteValues = @(
                @{parametername = 'SiteID'; FolderCount = 6 }
                , @{parametername = 'SiteLocation'; FolderCount = 6 }
            )

            # This Mock should never be hit, it is just to prevent actual calls from being executed and get annoying results
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchResponse']
            } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchFolderNameResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?FolderName=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?Description=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?TreePath=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteID=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteLocation=[^\$]+$' } -Verifiable
        }
        Context 'Unit tests with existing custom windows credential' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = @{username = ''; password = '' }; AuthType = "WindowsCustom"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 Folders when no parameters are used' {
                (Get-PasswordStateFolder).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <FolderCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $FolderCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
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
    Describe "Get-PasswordStateFolder" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateFolder'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $ParameterSetCases = @(
                @{parametername = 'FolderName'; mandatory = 'False'; testvalue = "Active Directory" }
                , @{parametername = 'Description'; mandatory = 'False'; testvalue = "Root" }
                , @{parametername = 'TreePath'; mandatory = 'False'; testvalue = "\RootFolder\Oracle" }
                , @{parametername = 'SiteID'; mandatory = 'False'; testvalue = "1" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; testvalue = "0" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False' }
            )
            $ParameterValues = @(
                @{parametername = 'FolderName'; testvalue = "Active Directory"; FolderCount = 1 }
                , @{parametername = 'Description'; testvalue = "Root"; FolderCount = 1 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Oracle"; FolderCount = 1 }
            )
            $SiteValues = @(
                @{parametername = 'SiteID'; FolderCount = 6 }
                , @{parametername = 'SiteLocation'; FolderCount = 6 }
            )

            # This Mock should never be hit, it is just to prevent actual calls from being executed and get annoying results
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchResponse']
            } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchFolderNameResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?FolderName=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?Description=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?TreePath=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteID=[^\$]+$' } -Verifiable

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['FolderSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/folders\/\?SiteLocation=[^\$]+$' } -Verifiable
        }
        Context 'Unit tests for winapi' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -WindowsAuthOnly
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 Folders when no parameters are used' {
                (Get-PasswordStateFolder).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <FolderCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $FolderCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
        Context 'Unit tests for apikey' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -Apikey $APIKey
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 Folders when no parameters are used' {
                (Get-PasswordStateFolder).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <FolderCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $FolderCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
        Context 'Unit tests for custom windows credential' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -customcredentials $TestCredential
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return 6 Folders when no parameters are used' {
                (Get-PasswordStateFolder).Count | Should -BeExactly 6
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }

            It 'Should return <FolderCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count | Should -BeExactly $FolderCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $FolderCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}