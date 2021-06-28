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
Describe 'Get-PasswordStatePassword' {
    BeforeAll {
        $FunctionName = 'Get-PasswordStatePassword'
        $BaseURI = 'https://passwordstate.local'
        $APIKey = 'SuperSecretKey'
        $ProfilePath = 'TestDrive:'
        $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
        $Paramattributetype='System.Management.Automation.ParameterAttribute'
        . "$($PSScriptRoot)\json\enum-jsonfiles.ps1"
    }
    Context 'Parameter Validation' -Foreach @(
        @{parametername = 'Search'; mandatory = 'False'; ParameterSetName = "General" }
        @{parametername = 'Title'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'UserName'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'HostName'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'ADDomainNetBios'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'AccountType'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'Description'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'Notes'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'URL'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'SiteID'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'SiteLocation'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField1'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField2'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField3'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField4'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField5'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField6'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField7'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField8'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField9'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'GenericField10'; mandatory = 'False'; ParameterSetName = "Specific" }
        @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
        @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
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
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>"' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($ParameterName)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>" for alias <alias>' -ForEach @(
            @{parametername = 'ADDomainNetBios'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53; alias='Domain' }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($alias)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Windows Authentication' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -WindowsAuthOnly -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>"' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($ParameterName)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>" for alias <alias>' -ForEach @(
            @{parametername = 'ADDomainNetBios'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53; alias='Domain' }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($alias)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Custom Credential' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -customcredentials $TestCredential -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>"' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($ParameterName)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>" for alias <alias>' -ForEach @(
            @{parametername = 'ADDomainNetBios'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53; alias='Domain' }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($alias)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with API key and reason provided' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -Apikey $APIKey -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' -and 'Headers' -in $extraparams.keys} -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason provided'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason provided'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason provided'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason provided'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True -Reason 'Audit reason provided'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason provided'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason provided'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason provided'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>"' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason provided'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($ParameterName)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>" for alias <alias>' -ForEach @(
            @{parametername = 'ADDomainNetBios'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53; alias='Domain' }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason provided'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($alias)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Windows Authentication and reason provided' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -WindowsAuthOnly -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>"' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($ParameterName)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>" for alias <alias>' -ForEach @(
            @{parametername = 'ADDomainNetBios'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53; alias='Domain' }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($alias)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit tests with Custom Credential' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -customcredentials $TestCredential -path $ProfilePath | Out-Null
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordSearch$($ParameterName)Response"] } -ParameterFilter { $uri -and $uri -match '\/searchpasswords\/(\d+){0,1}\?\w+=[^\&]+$' } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID>' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> without PasswordListID and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -PreventAuditing:`$True -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName) -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return <ListCount> for parameter <parametername> with PasswordListID <PWLID> and PreventAudit set to True' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $Result = if ($parametername -ne '') {
                ((Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'" ) | Measure-Object).Count
            }
            else {
                ((Invoke-Expression -Command "$($FunctionName)" ) | Measure-Object).Count
            }
            $Result | Should -BeExactly $ListCount
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>"' -ForEach @(
            @{parametername = 'Title'; testvalue = "Demo AD Username"; ListCount = 2; PWLID = 53 }
            @{parametername = 'UserName'; testvalue = "username1"; ListCount = 3; PWLID = 53 }
            @{parametername = 'HostName'; testvalue = "HostA"; ListCount = 4; PWLID = 53 }
            @{parametername = 'Domain'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53 }
            @{parametername = 'AccountType'; testvalue = ""; ListCount = 1; PWLID = 53 } # testvalue must be empty because the actual property is AccountTypeID
            @{parametername = 'Description'; testvalue = "Description for "; ListCount = 6; PWLID = 53 }
            @{parametername = 'Notes'; testvalue = "Same Notes"; ListCount = 7; PWLID = 53 }
            @{parametername = 'URL'; testvalue = "https://passworstate.local"; ListCount = 8; PWLID = 53 }
            @{parametername = 'SiteID'; testvalue = ""; ListCount = 9; PWLID = 53 }
            @{parametername = 'SiteLocation'; testvalue = ""; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField1'; testvalue = "TestField1"; ListCount = 11; PWLID = 53 }
            @{parametername = 'GenericField2'; testvalue = "TestField2"; ListCount = 12; PWLID = 53 }
            @{parametername = 'GenericField3'; testvalue = "TestField3"; ListCount = 13; PWLID = 53 }
            @{parametername = 'GenericField4'; testvalue = "TestField4"; ListCount = 14; PWLID = 53 }
            @{parametername = 'GenericField5'; testvalue = "TestField5"; ListCount = 15; PWLID = 53 }
            @{parametername = 'GenericField6'; testvalue = "TestField6"; ListCount = 16; PWLID = 53 }
            @{parametername = 'GenericField7'; testvalue = "TestField7"; ListCount = 17; PWLID = 53 }
            @{parametername = 'GenericField8'; testvalue = "TestField8"; ListCount = 18; PWLID = 53 }
            @{parametername = 'GenericField9'; testvalue = "TestField9"; ListCount = 19; PWLID = 53 }
            @{parametername = 'GenericField10'; testvalue = "TestField10"; ListCount = 20; PWLID = 53 }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($ParameterName)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should have a <parametername> matching "<testvalue>" for alias <alias>' -ForEach @(
            @{parametername = 'ADDomainNetBios'; testvalue = "MYDomain"; ListCount = 5; PWLID = 53; alias='Domain' }
        ) {
            $ResultValues = Invoke-Expression -Command "$($FunctionName) -$($Parametername) '$($testvalue)' -Reason 'Audit reason specified'"
            foreach ($ResultValue in $ResultValues) {
                $ResultValue."$($alias)" | Should -Match $testvalue
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
}