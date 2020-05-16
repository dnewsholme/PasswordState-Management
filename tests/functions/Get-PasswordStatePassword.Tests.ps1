Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-Module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStatePassword parameter validation" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePassword'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'Search'; mandatory = 'False'; ParameterSetName = "General" }
                @{parametername = 'Title'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'UserName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Domain'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'AccountType'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Notes'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'URL'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField1'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField2'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField3'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField4'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField5'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField6'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField7'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField8'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField9'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField10'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterSpecificValues = @(
                @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
                , @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
                , @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
                , @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
                , @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
                , @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
                , @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
                , @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
                , @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
                , @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
                , @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
                , @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
                , @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
                , @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
                , @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
                , @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
                , @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
                , @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
            )

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable

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
        }
    }
}

Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-Module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStatePassword with winapi profile" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePassword'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'Search'; mandatory = 'False'; ParameterSetName = "General" }
                @{parametername = 'Title'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'UserName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Domain'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'AccountType'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Notes'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'URL'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField1'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField2'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField3'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField4'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField5'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField6'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField7'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField8'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField9'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField10'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterSpecificValues = @(
                @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
                , @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
                , @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
                , @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
                , @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
                , @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
                , @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
                , @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
                , @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
                , @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
                , @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
                , @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
                , @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
                , @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
                , @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
                , @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
                , @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
                , @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
            )

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable

        }
        Context 'Unit tests with winapi profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = ""; AuthType = "WindowsIntegrated"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ResultValue in $ResultValues) {
                    $ResultValue."$($ParameterName)" | Should -Match $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}
Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-Module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStatePassword with Custom Credentials in profile" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePassword'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'Search'; mandatory = 'False'; ParameterSetName = "General" }
                @{parametername = 'Title'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'UserName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Domain'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'AccountType'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Notes'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'URL'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField1'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField2'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField3'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField4'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField5'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField6'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField7'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField8'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField9'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField10'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterSpecificValues = @(
                @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
                , @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
                , @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
                , @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
                , @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
                , @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
                , @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
                , @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
                , @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
                , @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
                , @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
                , @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
                , @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
                , @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
                , @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
                , @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
                , @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
                , @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
            )

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable

        }
        Context 'Unit tests with Custom Credentials profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = @{username = ($TestCredential.username ) ; password = ($TestCredential.Password | ConvertFrom-SecureString ) }; AuthType = "WindowsCustom"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ResultValue in $ResultValues) {
                    $ResultValue."$($ParameterName)" | Should -Match $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}
Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-Module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStatePassword with apikey in profile" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePassword'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'Search'; mandatory = 'False'; ParameterSetName = "General" }
                @{parametername = 'Title'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'UserName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Domain'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'AccountType'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Notes'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'URL'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField1'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField2'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField3'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField4'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField5'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField6'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField7'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField8'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField9'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField10'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterSpecificValues = @(
                @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
                , @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
                , @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
                , @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
                , @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
                , @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
                , @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
                , @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
                , @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
                , @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
                , @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
                , @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
                , @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
                , @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
                , @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
                , @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
                , @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
                , @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
            )

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable

        }
        Context 'Unit tests with apiKey profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = ($APIKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString ); AuthType = "APIKey"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ResultValue in $ResultValues) {
                    $ResultValue."$($ParameterName)" | Should -Match $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}
Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-Module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStatePassword for winapi" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePassword'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $ParameterSetCases = @(
                @{parametername = 'Search'; mandatory = 'False'; ParameterSetName = "General" }
                @{parametername = 'Title'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'UserName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Domain'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'AccountType'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Notes'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'URL'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField1'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField2'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField3'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField4'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField5'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField6'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField7'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField8'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField9'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'GenericField10'; mandatory = 'False'; ParameterSetName = "Specific" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            $ParameterSpecificValues = @(
                @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
                , @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
                , @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
                , @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
                , @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
                , @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
                , @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
                , @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
                , @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
                , @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
                , @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
                , @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
                , @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
                , @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
                , @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
                , @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
                , @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
                , @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
                , @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
            )

            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordSearch$($ParameterName)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable

        }
        Context 'Unit tests for winapi' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -WindowsAuthOnly
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ResultValue in $ResultValues) {
                    $ResultValue."$($ParameterName)" | Should -Match $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
        Context 'Unit tests for Custom Credentials' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -customcredentials $TestCredential
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ResultValue in $ResultValues) {
                    $ResultValue."$($ParameterName)" | Should -Match $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
        Context 'Unit tests for apiKey' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Uri $BaseURI -Apikey $APIKey
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount, $PWLID)
                $Result = if ($parametername -ne '') {
                    ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
                }
                else {
                    ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
                }
                $Result | Should -BeExactly $ListCount
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have a <parametername> matching "<testvalue>"' -TestCases $ParameterSpecificValues {
                param($parametername, $testvalue, $ListCount)
                $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
                foreach ($ResultValue in $ResultValues) {
                    $ResultValue."$($ParameterName)" | Should -Match $testvalue
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}