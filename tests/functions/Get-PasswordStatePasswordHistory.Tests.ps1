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
        $FunctionName = 'Get-PasswordStatePasswordHistory'
        $BaseURI = 'https://passwordstate.local'
        $APIKey = 'SuperSecretKey'
        $ProfilePath = 'TestDrive:'
        $TestCredential = [pscredential]::new('myuser', (ConvertTo-SecureString -AsPlainText -Force -String $APIKey))
        $Paramattributetype='System.Management.Automation.ParameterAttribute'
        . "$($PSScriptRoot)\json\enum-jsonfiles.ps1"
    }
    Context "Parameter Validation" -Foreach @(
        @{parametername = 'PasswordID'; mandatory = 'True'; ParameterSetName="__AllParameterSets" }
        , @{parametername = 'Reason'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
        , @{parametername = 'PreventAuditing'; mandatory = 'False'; ParameterSetName = "__AllParameterSets" }
    ) {
        It 'should verify if parameter "<parametername>" is present' {
            (Get-Command -Name $FunctionName).Parameters[$parametername] | Should -Not -BeNullOrEmpty
        }
        It 'should verify if mandatory for parameter "<parametername>" is set to "<mandatory>"' {
            "$(((Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().fullname -eq $Paramattributetype}).Mandatory)" | Should -be $mandatory
        }
        It 'should verify if parameter "<parametername>" is part of "<ParameterSetName>" ParameterSetName' {
            "$(((Get-Command -Name $FunctionName).Parameters[$parametername].Attributes | Where-Object { $_.GetType().fullname -eq $Paramattributetype}).ParameterSetName)" | Should -be $ParameterSetName
        }
    }
    Context 'Unit Tests with API key' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -Apikey $APIKey -path $ProfilePath | Out-Null
            $PasswordListId = 211
            $RightPasswordID = 9568
            $WrongPasswordID = 999
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordHistoryResponse"] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -Verifiable -MockWith { $Global:TestJSON["PasswordHistory$($PasswordID)Response"] } -ParameterFilter { $uri -and $uri -match '\/passwordhistory\/\d+' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith {
                $Details = [System.Management.Automation.ErrorDetails]::new('[{"errors":[{"message":"Not Found"},{"phrase":"A Password of ID ''999'' was not found in the database, or you do not have permissions to it."}]}]')
                $WebException=([System.Net.WebException]::new('{"errors":{"phrase":"ikke"}}',[system.net.webexceptionstatus]::protocolerror))
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($WebException,'',[System.Management.Automation.ErrorCategory]::ObjectNotFound, $null)
                $ErrorRecord.ErrorDetails = $Details
                throw $ErrorRecord } -ParameterFilter { $uri -and $uri -match "\/passwordhistory\/999" } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should throw when PasswordID does not exist' {
            { (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)") } | should -Throw
        }
        It 'Should return error with a specific error message' {
            try {
                (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)" -ErrorAction Stop)
            }
            catch [system.exception] {
                "$($_.exception)" | Should -MatchExactly "A Password of ID '$($WrongPasswordID)' was not found in the database, or you do not have permissions to it."
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return 1 history item for an existing passwordID' {
            (( Invoke-Expression -Command "$($FunctionName) -PasswordID $($RightPasswordID)") | Measure-Object).Count | Should -be 1
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit Tests with Windows Authentication' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -WindowsAuthOnly -path $ProfilePath | Out-Null
            $PasswordListId = 211
            $RightPasswordID = 9568
            $WrongPasswordID = 999
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordHistoryResponse"] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -Verifiable -MockWith { $Global:TestJSON["PasswordHistory$($PasswordID)Response"] } -ParameterFilter { $uri -and $uri -match '\/passwordhistory\/\d+' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith {
                $Details = [System.Management.Automation.ErrorDetails]::new('[{"errors":[{"message":"Not Found"},{"phrase":"A Password of ID ''999'' was not found in the database, or you do not have permissions to it."}]}]')
                $WebException=([System.Net.WebException]::new('{"errors":{"phrase":"ikke"}}',[system.net.webexceptionstatus]::protocolerror))
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($WebException,'',[System.Management.Automation.ErrorCategory]::ObjectNotFound, $null)
                $ErrorRecord.ErrorDetails = $Details
                throw $ErrorRecord } -ParameterFilter { $uri -and $uri -match "\/passwordhistory\/999" } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should throw when PasswordID does not exist' {
            { (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)") } | should -Throw
        }
        It 'Should return error with a specific error message' {
            try {
                (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)" -ErrorAction Stop)
            }
            catch [system.exception] {
                "$($_.exception)" | Should -MatchExactly "A Password of ID '$($WrongPasswordID)' was not found in the database, or you do not have permissions to it."
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return 1 history item for an existing passwordID' {
            (( Invoke-Expression -Command "$($FunctionName) -PasswordID $($RightPasswordID)") | Measure-Object).Count | Should -be 1
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
    Context 'Unit Tests with Custom Credential' {
        BeforeAll {
            Set-PasswordStateEnvironment -Uri $BaseURI -customcredentials $TestCredential -path $ProfilePath | Out-Null
            $PasswordListId = 211
            $RightPasswordID = 9568
            $WrongPasswordID = 999
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith { $Global:TestJSON["PasswordHistoryResponse"] }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -Verifiable -MockWith { $Global:TestJSON["PasswordHistory$($PasswordID)Response"] } -ParameterFilter { $uri -and $uri -match '\/passwordhistory\/\d+' }
            Mock -CommandName 'Get-PasswordStateResource' -ModuleName 'passwordstate-management' -MockWith {
                $Details = [System.Management.Automation.ErrorDetails]::new('[{"errors":[{"message":"Not Found"},{"phrase":"A Password of ID ''999'' was not found in the database, or you do not have permissions to it."}]}]')
                $WebException=([System.Net.WebException]::new('{"errors":{"phrase":"ikke"}}',[system.net.webexceptionstatus]::protocolerror))
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($WebException,'',[System.Management.Automation.ErrorCategory]::ObjectNotFound, $null)
                $ErrorRecord.ErrorDetails = $Details
                throw $ErrorRecord } -ParameterFilter { $uri -and $uri -match "\/passwordhistory\/999" } -Verifiable
        }
        AfterAll {
            Remove-Item -Path "$([environment]::GetFolderPath("UserProfile"))\Passwordstate.json" -Force -Confirm:$false -ErrorAction SilentlyContinue
        }
        It 'Should throw when PasswordID does not exist' {
            { (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)") } | should -Throw
        }
        It 'Should return error with a specific error message' {
            try {
                (Invoke-Expression -Command "$($FunctionName) -PasswordID $($WrongPasswordID)" -ErrorAction Stop)
            }
            catch [system.exception] {
                "$($_.exception)" | Should -MatchExactly "A Password of ID '$($WrongPasswordID)' was not found in the database, or you do not have permissions to it."
            }
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
        It 'Should return 1 history item for an existing passwordID' {
            (( Invoke-Expression -Command "$($FunctionName) -PasswordID $($RightPasswordID)") | Measure-Object).Count | Should -be 1
            InModuleScope 'passwordstate-management' {
                Should -Invoke 'Get-PasswordstateResource' -Exactly -Times 1 -Scope It
            }
        }
    }
}