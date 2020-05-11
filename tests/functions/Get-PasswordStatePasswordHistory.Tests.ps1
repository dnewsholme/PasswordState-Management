Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope -ModuleName 'PasswordState-Management' {
    Describe "Get-PasswordStatePasswordHistory" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePasswordHistory'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $RightPasswordID = 9568
            $WrongPasswordID = 999
            $ParameterSetCases = @(
                @{parametername = 'PasswordID'; mandatory = 'True'; ParameterSetName="__AllParameterSets" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordHistoryResponse"]
            }

            Mock -CommandName 'Get-PasswordStateResource' -Verifiable -MockWith {
                $Global:TestJSON["PasswordHistory$($PasswordID)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/passwordhistory\/\d+' }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Details = [System.Management.Automation.ErrorDetails]::new('[{"errors":[{"message":"Not Found"},{"phrase":"A Password of ID ''999'' was not found in the database, or you do not have permissions to it."}]}]')
                $WebException=([System.Net.WebException]::new('{"errors":{"phrase":"ikke"}}',[system.net.webexceptionstatus]::protocolerror))
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($WebException,'',[System.Management.Automation.ErrorCategory]::ObjectNotFound, $null)
                $ErrorRecord.ErrorDetails = $Details
                throw $ErrorRecord
            } -ParameterFilter { $uri -and $uri -match "\/passwordhistory\/999" } -Verifiable
        }
        Context "Parameter Validation" {
            It 'should verify if parameter "<parametername>" is present' -TestCases $ParameterSetCases {
                param($parametername)
                (Get-Command -Name $FunctionName).Parameters[$parametername] | Should -Not -BeNullOrEmpty
            }
            It 'should verify if mandatory for parameter "<parametername>" is set to "<mandatory>"' -TestCases $ParameterSetCases {
                param($parametername, $mandatory)
                "$(((Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().fullname -eq 'System.Management.Automation.ParameterAttribute'}).Mandatory)" | Should -be $mandatory
            }
            It 'should verify if parameter "<parametername>" is part of "<ParameterSetName>" ParameterSetName' -TestCases $ParameterSetCases {
                param($parametername, $ParameterSetName)
                "$(((Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().fullname -eq 'System.Management.Automation.ParameterAttribute'}).ParameterSetName)" | Should -be $ParameterSetName
            }
        }
    }
}

Remove-Module PasswordState-Management -Force -ErrorAction SilentlyContinue
Import-module "$($PSScriptRoot)\..\..\Passwordstate-management.psd1" -Force
. "$($PSScriptRoot)\json\enum-jsonFiles.ps1"
InModuleScope -ModuleName 'PasswordState-Management' {
    Describe "Get-PasswordStatePasswordHistory" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePasswordHistory'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $RightPasswordID = 9568
            $WrongPasswordID = 999
            $ParameterSetCases = @(
                @{parametername = 'PasswordID'; mandatory = 'True'; ParameterSetName="__AllParameterSets" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordHistoryResponse"]
            }

            Mock -CommandName 'Get-PasswordStateResource' -Verifiable -MockWith {
                $Global:TestJSON["PasswordHistory$($PasswordID)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/passwordhistory\/\d+' }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Details = [System.Management.Automation.ErrorDetails]::new('[{"errors":[{"message":"Not Found"},{"phrase":"A Password of ID ''999'' was not found in the database, or you do not have permissions to it."}]}]')
                $WebException=([System.Net.WebException]::new('{"errors":{"phrase":"ikke"}}',[system.net.webexceptionstatus]::protocolerror))
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($WebException,'',[System.Management.Automation.ErrorCategory]::ObjectNotFound, $null)
                $ErrorRecord.ErrorDetails = $Details
                throw $ErrorRecord
            } -ParameterFilter { $uri -and $uri -match "\/passwordhistory\/999" } -Verifiable
        }
        Context 'Unit tests with winapi profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = ""; AuthType = "WindowsIntegrated"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should throw when PasswordID does not exist' {
                { (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)") } | should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return error with a specific error message' {
                try {
                    (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)" -ErrorAction Stop)
                }
                catch [system.exception] {
                    "$($_.exception)" | Should -MatchExactly "A Password of ID '$($WrongPasswordID)' was not found in the database, or you do not have permissions to it."
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return 2 history items for an existing passwordID' {
                (( Invoke-Expression -Command "$($FunctionName) -PasswordID $($RightPasswordID)") | Measure-Object).Count | Should -be 2
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
InModuleScope -ModuleName 'PasswordState-Management' {
    Describe "Get-PasswordStatePasswordHistory" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePasswordHistory'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $RightPasswordID = 9568
            $WrongPasswordID = 999
            $ParameterSetCases = @(
                @{parametername = 'PasswordID'; mandatory = 'True'; ParameterSetName="__AllParameterSets" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordHistoryResponse"]
            }

            Mock -CommandName 'Get-PasswordStateResource' -Verifiable -MockWith {
                $Global:TestJSON["PasswordHistory$($PasswordID)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/passwordhistory\/\d+' }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Details = [System.Management.Automation.ErrorDetails]::new('[{"errors":[{"message":"Not Found"},{"phrase":"A Password of ID ''999'' was not found in the database, or you do not have permissions to it."}]}]')
                $WebException=([System.Net.WebException]::new('{"errors":{"phrase":"ikke"}}',[system.net.webexceptionstatus]::protocolerror))
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($WebException,'',[System.Management.Automation.ErrorCategory]::ObjectNotFound, $null)
                $ErrorRecord.ErrorDetails = $Details
                throw $ErrorRecord
            } -ParameterFilter { $uri -and $uri -match "\/passwordhistory\/999" } -Verifiable
        }
        Context 'Unit tests with Custom Credentials profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = @{username = ($TestCredential.username ) ; password = ($TestCredential.Password | ConvertFrom-SecureString ) }; AuthType = "WindowsCustom"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should throw when PasswordID does not exist' {
                { (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)") } | should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return error with a specific error message' {
                try {
                    (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)" -ErrorAction Stop)
                }
                catch [system.exception] {
                    "$($_.exception)" | Should -MatchExactly "A Password of ID '$($WrongPasswordID)' was not found in the database, or you do not have permissions to it."
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return 2 history items for an existing passwordID' {
                (( Invoke-Expression -Command "$($FunctionName) -PasswordID $($RightPasswordID)") | Measure-Object).Count | Should -be 2
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
InModuleScope -ModuleName 'PasswordState-Management' {
    Describe "Get-PasswordStatePasswordHistory" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePasswordHistory'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $RightPasswordID = 9568
            $WrongPasswordID = 999
            $ParameterSetCases = @(
                @{parametername = 'PasswordID'; mandatory = 'True'; ParameterSetName="__AllParameterSets" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordHistoryResponse"]
            }

            Mock -CommandName 'Get-PasswordStateResource' -Verifiable -MockWith {
                $Global:TestJSON["PasswordHistory$($PasswordID)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/passwordhistory\/\d+' }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Details = [System.Management.Automation.ErrorDetails]::new('[{"errors":[{"message":"Not Found"},{"phrase":"A Password of ID ''999'' was not found in the database, or you do not have permissions to it."}]}]')
                $WebException=([System.Net.WebException]::new('{"errors":{"phrase":"ikke"}}',[system.net.webexceptionstatus]::protocolerror))
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($WebException,'',[System.Management.Automation.ErrorCategory]::ObjectNotFound, $null)
                $ErrorRecord.ErrorDetails = $Details
                throw $ErrorRecord
            } -ParameterFilter { $uri -and $uri -match "\/passwordhistory\/999" } -Verifiable
        }
        Context 'Unit tests with apiKey profile' {
            BeforeAll {
                Set-Content -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Value (@{Baseuri = $BaseURI; Apikey = ($APIKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString ); AuthType = "APIKey"; TimeoutSeconds = 60 } | ConvertTo-Json) -Force -Confirm:$false
            }
            AfterAll {
                Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should throw when PasswordID does not exist' {
                { (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)") } | should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return error with a specific error message' {
                try {
                    (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)" -ErrorAction Stop)
                }
                catch [system.exception] {
                    "$($_.exception)" | Should -MatchExactly "A Password of ID '$($WrongPasswordID)' was not found in the database, or you do not have permissions to it."
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return 2 history items for an existing passwordID' {
                (( Invoke-Expression -Command "$($FunctionName) -PasswordID $($RightPasswordID)") | Measure-Object).Count | Should -be 2
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
InModuleScope -ModuleName 'PasswordState-Management' {
    Describe "Get-PasswordStatePasswordHistory" {
        BeforeAll {
            $FunctionName = 'Get-PasswordStatePasswordHistory'
            $BaseURI = 'https://passwordstate.local'
            $APIKey = 'SuperSecretKey'
            $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
            $PasswordListId = 211
            $RightPasswordID = 9568
            $WrongPasswordID = 999
            $ParameterSetCases = @(
                @{parametername = 'PasswordID'; mandatory = 'True'; ParameterSetName="__AllParameterSets" }
                , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
                , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
            )
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Global:TestJSON["PasswordHistoryResponse"]
            }

            Mock -CommandName 'Get-PasswordStateResource' -Verifiable -MockWith {
                $Global:TestJSON["PasswordHistory$($PasswordID)Response"]
            } -ParameterFilter { $uri -and $uri -match '\/passwordhistory\/\d+' }
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                $Details = [System.Management.Automation.ErrorDetails]::new('[{"errors":[{"message":"Not Found"},{"phrase":"A Password of ID ''999'' was not found in the database, or you do not have permissions to it."}]}]')
                $WebException=([System.Net.WebException]::new('{"errors":{"phrase":"ikke"}}',[system.net.webexceptionstatus]::protocolerror))
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($WebException,'',[System.Management.Automation.ErrorCategory]::ObjectNotFound, $null)
                $ErrorRecord.ErrorDetails = $Details
                throw $ErrorRecord
            } -ParameterFilter { $uri -and $uri -match "\/passwordhistory\/999" } -Verifiable
        }
        Context 'Unit tests for winapi' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -WindowsAuthOnly
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should throw when PasswordID does not exist' {
                { (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)") } | should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return error with a specific error message' {
                try {
                    (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)" -ErrorAction Stop)
                }
                catch [system.exception] {
                    "$($_.exception)" | Should -MatchExactly "A Password of ID '$($WrongPasswordID)' was not found in the database, or you do not have permissions to it."
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return 2 history items for an existing passwordID' {
                (( Invoke-Expression -Command "$($FunctionName) -PasswordID $($RightPasswordID)") | Measure-Object).Count | Should -be 2
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
        Context 'Unit tests for Custom Credential' {
            BeforeAll {
                Set-PasswordStateEnvironment -path 'TestDrive:' -Baseuri $BaseURI -customcredentials $TestCredential
            }
            AfterAll {
                Remove-Item -Path 'TestDrive:\Passwordstate.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
            It 'Should throw when PasswordID does not exist' {
                { (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)") } | should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return error with a specific error message' {
                try {
                    (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)" -ErrorAction Stop)
                }
                catch [system.exception] {
                    "$($_.exception)" | Should -MatchExactly "A Password of ID '$($WrongPasswordID)' was not found in the database, or you do not have permissions to it."
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return 2 history items for an existing passwordID' {
                (( Invoke-Expression -Command "$($FunctionName) -PasswordID $($RightPasswordID)") | Measure-Object).Count | Should -be 2
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
            It 'Should throw when PasswordID does not exist' {
                { (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)") } | should -Throw
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return error with a specific error message' {
                try {
                    (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)" -ErrorAction Stop)
                }
                catch [system.exception] {
                    "$($_.exception)" | Should -MatchExactly "A Password of ID '$($WrongPasswordID)' was not found in the database, or you do not have permissions to it."
                }
                Assert-MockCalled -CommandName 'Get-PasswordStateResource' -Exactly -Times 1 -Scope It
            }
            It 'Should return 2 history items for an existing passwordID' {
                (( Invoke-Expression -Command "$($FunctionName) -PasswordID $($RightPasswordID)") | Measure-Object).Count | Should -be 2
            }
            It 'Should have called function Get-PasswordStateResource' {
                Assert-MockCalled -CommandName 'Get-PasswordStateResource'
            }
        }
    }
}