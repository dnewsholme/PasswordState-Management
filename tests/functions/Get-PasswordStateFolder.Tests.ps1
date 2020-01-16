InModuleScope 'Passwordstate-Management' {
    Describe "Get-PasswordStateFolder" {
        BeforeAll {
            $FunctionName='Get-PasswordStateFolder'
            $ParameterSetCases=@(
                 @{parametername='FolderName';mandatory='False'}
                ,@{parametername='Description';mandatory='False'}
                ,@{parametername='TreePath';mandatory='False'}
                ,@{parametername='SiteID';mandatory='False'}
                ,@{parametername='SiteLocation';mandatory='False'}
                ,@{parametername='PreventAuditing';mandatory='False'}
            )
            Mock -CommandName 'Get-PasswordStateResource' -MockWith {
                
            }
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
        Context 'Unit tests' {
        }
    }
}