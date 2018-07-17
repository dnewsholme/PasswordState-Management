$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Import-Module "$here\..\passwordstate-management.psm1"
Describe "Remove-PasswordStatePassword" {
    It "Removes a Password From Password State" {
        Mock -CommandName Get-PasswordStateResource -MockWith {return [PSCustomObject]@{
                "Title"          = "testuser"
                "Username"       = "test"
                "Domain"         = ""
                "Description"    = ""
                "PasswordId"     = 3
                "AccountType"    = ""
                "URL"            = ""
                "Passwordlist"   = "MockedList"
                "PasswordListID" = 7
            }
        } -ParameterFilter {$uri -eq "/api/passwords/7?QueryAll&ExcludePassword=true"}

        Mock -CommandName Get-PasswordStateResource -MockWith {return [PSCustomObject]@{
                "Title"          = "testuser"
                "Username"       = "test"
                "Password"       = "Password"
                "Domain"         = ""
                "Description"    = ""
                "PasswordId"     = 3
                "AccountType"    = ""
                "URL"            = ""
                "Passwordlist"   = "MockedList"
                "PasswordListID" = 7
            }
        } -ParameterFilter {$uri -eq "/api/passwords/3"}

        Mock -CommandName Get-PasswordStateList -MockWith {return [PSCustomObject]@{
                "PasswordListID"                = 7
                "PasswordList"                  = "MockedList"
                "Description"                   = ""
                "ImageFileName"                 = ""
                "Guide"                         = ""
                "AllowExport"                   = $true
                "PrivatePasswordList"           = $false
                "TimeBasedAccessRequired"       = $false
                "HandshakeApprovalRequired"     = $false
                "PasswordStrengthPolicyID"      = 1
                "PasswordGeneratorID"           = 0
                "CodePage"                      = "Using Passwordstate Default Code Page"
                "PreventPasswordReuse"          = 5
                "AuthenticationType"            = "None Required"
                "AuthenticationPerSession"      = $false
                "PreventExpiryDateModification" = $false
                "SetExpiryDate"                 = 0
                "ResetExpiryDate"               = 0
                "PreventDragDrop"               = $true
                "PreventBadPasswordUse"         = $true
                "ProvideAccessReason"           = $false
                "TreePath"                      = "\\SomePath\\Somesubpath"
                "TotalPasswords"                = 2
                "GeneratorName"                 = "Using user\u0027s personal Password Generator Options"
                "PolicyName"                    = "Default Policy"
                "PasswordResetEnabled"          = $false
                "ForcePasswordGenerator"        = $false
                "HidePasswords"                 = $false
                "ShowGuide"                     = $false
                "EnablePasswordResetSchedule"   = $false
                "PasswordResetSchedule"         = "00:00"
                "AddDaysToExpiryDate"           = 90
                "SiteID"                        = 0
                "SiteLocation"                  = $null
            }
        }
        Mock -CommandName Get-PasswordStateEnvironment -MockWith {return [PSCustomObject]@{
                "Baseuri" = "https://passwordstateserver.co.uk"
                "APIKey"  = "WindowsAuth"

            }
        }
        Mock -CommandName Remove-PasswordStateResource -MockWith {return $null
        } -ParameterFilter {$uri -eq "/api/passwords/3?MoveToRecycleBin=True"}
        (Remove-PasswordStatePassword -PasswordID 3 -SendToRecycleBin) | Should -BeNullOrEmpty
    }
}
