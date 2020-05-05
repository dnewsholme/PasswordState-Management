Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope 'PasswordState-Management' {
    Describe 'Set-PasswordStateEnvironment' {
        BeforeAll {
            $FunctionName='Set-PasswordStateEnvironment'
            $ParameterTestCases=@(
                 @{ParameterName='Uri';Mandatory='True';ParameterSetName='__AllParameterSets'}
                ,@{ParameterName='ApiKey';Mandatory='False';ParameterSetName='One'}
                ,@{ParameterName='PasswordGeneratorAPIkey';Mandatory='False';ParameterSetName='One'}
                ,@{ParameterName='WindowsAuthOnly';Mandatory='False';ParameterSetName='Two'}
                ,@{ParameterName='customcredentials';Mandatory='False';ParameterSetName='Three'}
                ,@{ParameterName='Path';Mandatory='False';ParameterSetName='__AllParameterSets'}
                ,@{ParameterName='SetPlainTextPasswords';Mandatory='False';ParameterSetName='__AllParameterSets'}
            )
            $AuthTestCases=@(
                @{Uri='https://norealurl1.local'}
                @{Uri='https://norealurl2.local'}
                @{Uri='https://norealurl3.local'}
            )
            $BaseUriAuthTestCases=@(
                @{Baseuri='https://norealurl1.local'}
                @{Baseuri='https://norealurl2.local'}
                @{Baseuri='https://norealurl3.local'}
            )
            $apiKey='somekey'
            $UserName = 'user'
            $Credential=[pscredential]::new( $UserName ,(ConvertTo-SecureString -AsPlainText -Force -String 'pass'))
            $ProfilePath='TestDrive:\'
            $ProfileFile="$($ProfilePath)\passwordstate.json"
        }
        Context 'Parameter Validation' {
            It 'Should have a parameter "<ParameterName>"' -TestCases $ParameterTestCases {
                param($ParameterName)
                (Get-Command -Name $FunctionName).Parameters[$ParameterName] | should -Not -BeNullOrEmpty
            }
            It 'Should verify if the mandatory property of parameter <ParameterName> is set to "<Mandatory>"' -TestCases $ParameterTestCases {
                param($ParameterName, $Mandatory)
                "$(((Get-Command -Name $FunctionName).Parameters[$ParameterName].Attributes | Where-Object { $_.gettype().Fullname -eq 'System.Management.Automation.ParameterAttribute'}).Mandatory)" | should -be $Mandatory
            }
            It 'Should verify if parameter <ParameterName> is part of ParameterSetName "<ParameterSetName>"' -TestCases $ParameterTestCases {
                param($ParameterName, $ParameterSetName)
                (((Get-Command -Name $FunctionName).Parameters[$ParameterName].Attributes | Where-Object { $_.gettype().Fullname -eq 'System.Management.Automation.ParameterAttribute'})).ParameterSetName | should -be $ParameterSetName

            }
        }
        Context 'Unit testing with api' {
            It 'should throw an error for "<Uri>" when no apikey is provided' -TestCases $AuthTestCases {
                param($Uri)
                { Set-PasswordStateEnvironment -Uri $Uri -path $ProfilePath -ErrorAction Stop } | Should -throw
            }
            It 'Should verify if a json file is written and Uri contains <Uri>' -TestCases $AuthTestCases {
                param($Uri)
                Set-PasswordStateEnvironment -Uri $Uri -Apikey $apikey -path $ProfilePath
                (Get-Content $ProfileFile | ConvertFrom-Json).BaseUri | should -be $Uri
            }
            It 'Should verify if a json file is written and Baseuri contains <Baseuri>' -TestCases $BaseUriAuthTestCases {
                param($Baseuri)
                Set-PasswordStateEnvironment -BaseUri $Baseuri -Apikey $apikey -path $ProfilePath
                (Get-Content $ProfileFile | ConvertFrom-Json).BaseUri | should -be $Baseuri
            }
            It 'Should verify if a json file is written and apikey is not empty for <Uri>' -TestCases $AuthTestCases {
                param($Uri)
                Set-PasswordStateEnvironment -Uri $Uri -Apikey $apikey -path $ProfilePath
                (Get-Content $ProfileFile | ConvertFrom-Json).apikey | should -Not -BeNullOrEmpty
            }
            It 'Should verify if a json file is written and AuthType is exactly "APIKey" for <Uri>' -TestCases $AuthTestCases {
                param($Uri)
                Set-PasswordStateEnvironment -Uri $Uri -Apikey $apikey -path $ProfilePath
                (Get-Content $ProfileFile | ConvertFrom-Json).AuthType | Should -BeExactly 'APIKey'
            }
        }
        Context 'Unit testing with Windows Authentication' {
            It 'should verify if a json file is witten and BaseUri contains <Uri>' -TestCases $AuthTestCases {
                param($Uri)
                Set-PasswordStateEnvironment -Uri $Uri -path $ProfilePath -WindowsAuthOnly
                (Get-Content $ProfileFile | ConvertFrom-Json).BaseUri | should -be $Uri
            }
            It 'should verify if a json file is witten and BaseUri contains <Baseuri>' -TestCases $BaseUriAuthTestCases {
                param($Baseuri)
                Set-PasswordStateEnvironment -Baseuri $Baseuri -path $ProfilePath -WindowsAuthOnly
                (Get-Content $ProfileFile | ConvertFrom-Json).BaseUri | should -be $Baseuri
            }
            It 'Should verify if a json file is written and apikey is empty for <Uri>' -TestCases $AuthTestCases {
                param($Uri)
                Set-PasswordStateEnvironment -Uri $Uri -path $ProfilePath -WindowsAuthOnly
                (Get-Content $ProfileFile | ConvertFrom-Json).apikey | should -BeNullOrEmpty
            }
            It 'Should verify if a json file is written and AuthType is exactly "WindowsIntegrated" for <Uri>' -TestCases $AuthTestCases {
                param($Uri)
                Set-PasswordStateEnvironment -Uri $Uri -path $ProfilePath -WindowsAuthOnly
                (Get-Content $ProfileFile | ConvertFrom-Json).AuthType | should -BeExactly "WindowsIntegrated"
            }
        }
        Context 'Unit testing with Windows Custom Credential' {
            It 'should verify if a json file is witten and Uri contains <Uri>' -TestCases $AuthTestCases {
                param($Uri)
                Set-PasswordStateEnvironment -Uri $Uri -path $ProfilePath -customcredentials $Credential
                (Get-Content $ProfileFile | ConvertFrom-Json).BaseUri | should -be $Uri
            }
            It 'should verify if a json file is witten and Baseuri contains <Baseuri>' -TestCases $BaseuriAuthTestCases {
                param($Baseuri)
                Set-PasswordStateEnvironment -Baseuri $Baseuri -path $ProfilePath -customcredentials $Credential
                (Get-Content $ProfileFile | ConvertFrom-Json).BaseUri | should -be $Baseuri
            }
            It 'Should verify if a json file is written and apikey has a credential' -TestCases $AuthTestCases {
                param($Uri)
                Set-PasswordStateEnvironment -Uri $Uri -path $ProfilePath -customcredentials $Credential
                (Get-Content $ProfileFile | ConvertFrom-Json).apikey.username | should -BeExactly $UserName
            }
            It 'Should verify if a json file is written and AuthType is exactly "WindowsIntegrated" for <Uri>' -TestCases $AuthTestCases {
                param($Uri)
                Set-PasswordStateEnvironment -Uri $Uri -path $ProfilePath -customcredentials $Credential
                (Get-Content $ProfileFile | ConvertFrom-Json).AuthType | should -BeExactly "WindowsCustom"
            }
        }
    }
}