Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateList'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'PasswordListID'; mandatory = 'False'; ParameterSetName = "ID" }
                , @{parametername = 'PasswordList'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'TreePath'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                @{parametername = ''; testvalue = ""; ListCount = 8 }
                , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
                , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
                , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }
            )

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListResponse']
            }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchPasswordListResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?PasswordList=[^\&]+$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?Description=[^\&]+$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?TreePath=[^\&]+$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteID=[^\&]+$' }

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteLocation=[^\&]+$' }

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
            It 'should verify if parameter "<parametername>" is part of "<parametersetname>" ParameterSetName' -TestCases $ParameterSetCases {
                param($parametername, $parametersetname)
                "$(((Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().fullname -eq 'System.Management.Automation.ParameterAttribute'}).ParameterSetName)" | Should -be $ParameterSetName
            }
        } } }
Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateList'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'PasswordListID'; mandatory = 'False'; ParameterSetName = "ID" }
                , @{parametername = 'PasswordList'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'TreePath'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                @{parametername = ''; testvalue = ""; ListCount = 8 }
                , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
                , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
                , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }
            )
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListResponse']
            }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchPasswordListResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?PasswordList=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?Description=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?TreePath=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteID=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteLocation=[^\&]+$' }
        
        }
        Context 'Unit tests with winapi profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = ""; AuthType = "WindowsIntegrated"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                } else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
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
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateList'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'PasswordListID'; mandatory = 'False'; ParameterSetName = "ID" }
                , @{parametername = 'PasswordList'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'TreePath'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                @{parametername = ''; testvalue = ""; ListCount = 8 }
                , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
                , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
                , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }
            )
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListResponse']
            }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchPasswordListResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?PasswordList=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?Description=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?TreePath=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteID=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteLocation=[^\&]+$' }
        
        }
        Context 'Unit tests with Custom credential profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = @{username = ''; password = '' }; AuthType = "WindowsCustom"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                } else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
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
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateList'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'PasswordListID'; mandatory = 'False'; ParameterSetName = "ID" }
                , @{parametername = 'PasswordList'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'TreePath'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                @{parametername = ''; testvalue = ""; ListCount = 8 }
                , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
                , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
                , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }
            )
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListResponse']
            }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchPasswordListResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?PasswordList=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?Description=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?TreePath=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteID=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteLocation=[^\&]+$' }
        
        }
        Context 'Unit tests with APIKey profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = $APIKey; AuthType = "APIKey"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                } else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
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
    Describe "Get-PasswordStateList" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStateList'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'PasswordListID'; mandatory = 'False'; ParameterSetName = "ID" }
                , @{parametername = 'PasswordList'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'TreePath'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterValues = @(
                @{parametername = ''; testvalue = ""; ListCount = 8 }
                , @{parametername = 'PasswordList'; testvalue = "AD User Accounts"; ListCount = 1 }
                , @{parametername = 'Description'; testvalue = "Oracle Accounts"; ListCount = 2 }
                , @{parametername = 'TreePath'; testvalue = "\\RootFolder\\Applications"; ListCount = 2 }
                , @{parametername = 'SiteID'; testvalue = "0"; ListCount = 8 }
                , @{parametername = 'SiteLocation'; testvalue = "Work"; ListCount = 4 }
            )
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListResponse']
            }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchPasswordListResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?PasswordList=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchDescriptionResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?Description=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchTreePathResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?TreePath=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteIDResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteID=[^\&]+$' }
        
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON['ListSearchSiteLocationResponse']
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswordlists\/\?SiteLocation=[^\&]+$' }
        
        }
        Context 'Unit tests for winapi' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -WindowsAuthOnly
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                } else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
        Context 'Unit tests for Custom credential' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -customcredentials $TestCredential
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                } else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
                $TestValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                ($TestValues | Select-Object -First 1)."$($ParameterName)" | Should -Match $testvalue
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
        Context 'Unit tests for APIKey' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -Apikey $APIKey
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                } else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching <testvalue>' -TestCases $ParameterValues {
                param($parametername, $testvalue, $ListCount)
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
