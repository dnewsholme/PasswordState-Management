BeforeAll {
    $FunctionName='Set-PasswordstateEnvironment'
    $AttributeType='System.Management.Automation.ParameterAttribute'
    $TestUri = 'https://passwordstate.local'
    $ProfilePath= 'TestDrive:\'
    $ApiKey='somekey'
    $UserName='someusername'
    $Password='SuperSecure'
    $Credential = [pscredential]::new( $UserName, (ConvertTo-SecureString -AsPlainText -String $Password -Force))
    Import-Module -Name "$($PSScriptRoot)\..\..\passwordstate-management.psd1" -Force
}
Describe 'Set-PasswordstateEnvironment' {
    BeforeAll {
        Import-Module -Name "$($PSScriptRoot)\..\..\passwordstate-management.psd1" -Force
    }
    AfterAll {
        Remove-Module -Name 'passwordstate-management' -ErrorAction SilentlyContinue
    }
    Context "Validate parameter '<ParameterName>'" -Foreach @(
        @{ParameterName='Uri';Mandatory='True';ParameterSetName='__AllParameterSets'}
       ,@{ParameterName='ApiKey';Mandatory='False';ParameterSetName='One'}
       ,@{ParameterName='PasswordGeneratorAPIkey';Mandatory='False';ParameterSetName='One'}
       ,@{ParameterName='WindowsAuthOnly';Mandatory='False';ParameterSetName='Two'}
       ,@{ParameterName='customcredentials';Mandatory='False';ParameterSetName='Three'}
       ,@{ParameterName='Path';Mandatory='False';ParameterSetName='__AllParameterSets'}
       ,@{ParameterName='SetPlainTextPasswords';Mandatory='False';ParameterSetName='__AllParameterSets'}
   ) {
        It 'has a parameter <ParameterName>' {
            $ParameterName | Should -BeIn (Get-Command -Name $FunctionName).Parameters.Keys
        }
        It 'Mandatory value of <ParameterName> is <Mandatory>' {
            $TestParameter = (Get-Command -Name $FunctionName).Parameters[$ParameterName]
            (($TestParameter.Attributes | Where-Object { $_.gettype().Fullname -eq $AttributeType}).Mandatory) | Should -BeExactly $Mandatory
        }
        It "should verify if parameter '<ParameterName>' is part of '<ParameterSetName>'" {
            (((Get-Command -Name $FunctionName).Parameters[$ParameterName].Attributes | Where-Object { $_.gettype().Fullname -eq $AttributeType})).ParameterSetName | should -be $ParameterSetName
        }
        
    }
    Context "Unit testing with api key" {
        BeforeEach {
            Import-Module -Name "$($PSScriptRoot)\..\..\passwordstate-management.psd1" -Force
        }
        AfterEach {
            Remove-Module -Name 'passwordstate-management' -ErrorAction SilentlyContinue
            if ( Get-Item -LiteralPath "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue ) {
                Remove-Item -Path "$($ProfilePath)\passwordstate.json" -Force
            }
        }
        It 'Should throw when no apikey is provided' {
            { Invoke-Expression "$FunctionName -Uri $TestUri -path $ProfilePath -Erroraction Stop"  } | Should -Throw
        }
        It 'Should verify if a passwordstate config file is written' {
            Invoke-Expression "$FunctionName -Uri '$TestUri' -apikey '$Apikey' -Path '$ProfilePath'" | Out-Null
            Get-Item -LiteralPath "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue | Should -not -BeNullOrEmpty
        }
        It "Should verify if <configname> has value '<Value>'" -ForEach @(
            @{configname='Baseuri';Value='https://passwordstate.local'}
            @{configname='AuthType';Value='APIKey'}
        ) {
            Invoke-Expression "$FunctionName -Uri '$TestUri' -apikey '$Apikey' -Path '$ProfilePath'" | Out-Null
            $ConfigFile = Get-Item -LiteralPath "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue
            $Config = Get-Content $ConfigFile | ConvertFrom-Json
            $Config."$configname" | Should -BeExactly $Value
        }
        It 'Should set the script parameter Path for future references' {
            Invoke-Expression "$FunctionName -Uri '$TestUri' -WindowsAuthOnly -Path '$ProfilePath'" | Out-Null
            InModuleScope -ModuleName 'passwordstate-management' {
                $Script:Preferences.Path | Should -BeExactly "TestDrive:\"
            }
        }
    }
    Context "Unit testing with Windows Authentication" {
        BeforeEach {
            Import-Module -Name "$($PSScriptRoot)\..\..\passwordstate-management.psd1" -Force
        }
        AfterEach {
            Remove-Module -Name 'passwordstate-management' -ErrorAction SilentlyContinue
            if ( Get-Item -LiteralPath "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue ) {
                Remove-Item -Path "$($ProfilePath)\passwordstate.json" -Force
            }
        }
        It 'Should verify if a passwordstate config file is written' {
            Invoke-Expression "$FunctionName -Uri '$TestUri' -WindowsAuthOnly -Path '$ProfilePath'" | Out-Null
            Get-Item -LiteralPath "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue | Should -not -BeNullOrEmpty
        }
        It "Should verify if <configname> has value '<Value>'" -ForEach @(
            @{configname='Baseuri';Value='https://passwordstate.local'}
            @{configname='AuthType';Value='WindowsIntegrated'}
            @{configname='apikey';Value=''}
        ) {
            Invoke-Expression "$FunctionName -Uri '$TestUri' -WindowsAuthOnly -Path '$ProfilePath'" | Out-Null
            $ConfigFile = Get-Item -LiteralPath "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue
            $Config = Get-Content $ConfigFile | ConvertFrom-Json
            $Config."$configname" | Should -BeExactly $Value
        }
        It 'Should set the script parameter Path for future references' {
            Invoke-Expression "$FunctionName -Uri '$TestUri' -WindowsAuthOnly -Path '$ProfilePath'" | Out-Null
            InModuleScope -ModuleName 'passwordstate-management' {
                $Script:Preferences.Path | Should -BeExactly "TestDrive:\"
            }
        }
    }
    Context "Unit testing with Windows custom credentials" {
        BeforeEach {
            Import-Module -Name "$($PSScriptRoot)\..\..\passwordstate-management.psd1" -Force
        }
        AfterEach {
            Remove-Module -Name 'passwordstate-management' -ErrorAction SilentlyContinue
            if ( Get-Item -LiteralPath "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue ) {
                Remove-Item -Path "$($ProfilePath)\passwordstate.json" -Force
            }
        }
        It 'Should verify if a passwordstate config file is written' {
            Set-PasswordstateEnvironment -Uri $TestUri -Customcredentials $Credential -Path $ProfilePath | Out-Null
            Get-Item -LiteralPath "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue | Should -not -BeNullOrEmpty
        }
        It "Should verify if <configname> has value '<Value>'" -ForEach @(
            @{configname='Baseuri';Value='https://passwordstate.local'}
            @{configname='AuthType';Value='WindowsCustom'}
        ) {
            Set-PasswordstateEnvironment -Uri $TestUri -Customcredentials $Credential -Path $ProfilePath | Out-Null
            $ConfigFile = Get-Item -LiteralPath "$($ProfilePath)\passwordstate.json" -ErrorAction SilentlyContinue
            $Config = Get-Content $ConfigFile | ConvertFrom-Json
            $Config."$configname" | Should -BeExactly $Value
        }
        It 'Should set the script parameter Path for future references' {
            Invoke-Expression "$FunctionName -Uri '$TestUri' -WindowsAuthOnly -Path '$ProfilePath'" | Out-Null
            InModuleScope -ModuleName 'passwordstate-management' {
                $Script:Preferences.Path | Should -BeExactly "TestDrive:\"
            }
        }
    }
}

AfterAll {
    Remove-Module -Name 'passwordstate-management' -ErrorAction SilentlyContinue
}