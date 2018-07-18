$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "New-PasswordStateList" {
    It "Creates " {
        Mock -CommandName New-PasswordStateResource -MockWith {return [PSCustomObject]@{

                PasswordListID                = 4
                PasswordList                  = "Test"
                Description                   = "Test"
                ImageFileName                 = ""
                Guide                         = ""
                AllowExport                   = "True"
                PrivatePasswordList           = "False"
                TimeBasedAccessRequired       = "False"
                HandshakeApprovalRequired     = "False"
                PasswordStrengthPolicyID      = 1
                PasswordGeneratorID           = 0
                CodePage                      = "Using Passwordstate Default Code Page"
                PreventPasswordReuse          = 5
                AuthenticationType            = "None Required"
                AuthenticationPerSession      = "False"
                PreventExpiryDateModification = "False"
                SetExpiryDate                 = 0
                ResetExpiryDate               = 0
                PreventDragDrop               = "True"
                PreventBadPasswordUse         = "True"
                ProvideAccessReason           = "False"
                TreePath                      = "\Root\Test"
                TotalPasswords                = 39
                GeneratorName                 = "Using user's personal Password Generator Options"
                PolicyName                    = "Default Policy"
                PasswordResetEnabled          = "False"
                ForcePasswordGenerator        = "False"
                HidePasswords                 = "False"
                ShowGuide                     = "False"
                EnablePasswordResetSchedule   = "False"
                PasswordResetSchedule         = "00:00"
                AddDaysToExpiryDate           = 90
                SiteID                        = 0
                SiteLocation                  = ""
            }
        } -ParameterFilter {$uri -eq "/api/passwordlists" -and $body -ne $null}
        (New-PasswordStateList -Name "test" -description "Test" -FolderID 3) | Should -not -benullorempty
    }
}
