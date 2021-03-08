[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Script is converting to secure string.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Script is converting to secure string.')]
# Create Class
param()

Class EncryptedPassword {
    EncryptedPassword ($Password) {
        $result = [string]::IsNullOrEmpty($Password)
        if ($result -eq $false) {
            $this.Password = ConvertTo-SecureString -String $Password -AsPlainText -Force
        }
        Else {
            $this.Password = $null
        }
    }
    [SecureString]$Password
}
class PasswordResult {
    # Properties
    [Nullable[System.Int32]]$PasswordID
    [String]$Title
    [Nullable[System.Int32]]$PasswordListID
    [String]$PasswordList
    [String]$Username
    $Password
    [String]GetPassword() {
        $result = [string]::IsNullOrEmpty($this.Password.Password)
        If ($this.Password.GetType().Name -ne 'String' -and $result -eq $false) {
            $SecureString = $this.Password.Password
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
            return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        }
        Elseif ($this.Password.GetType().Name -eq 'String') {
            return $this.Password
        }
        Else {
            # input was null so return null
            return $null
        }
    }
    DecryptPassword() {
        $this.Password = $this.GetPassword()
    }
    [PSCredential]ToPSCredential() {
        $user = ''
        if ($this.Username -match '(.*)@(.*)') {
            $user = "$($this.Username)"
        }
        else {
            if (-not ([String]::IsNullOrEmpty($this.Domain))) {
                $user += "$($this.Domain)\"
            }
            $user += "$($this.Username)"
        }
        If ($this.Password.GetType().Name -ne 'String') {
            $output = [PSCredential]::new($user, $this.Password.Password)
            return $output
        }

        Else {
            if ($this.Password.Length -lt 1) {
                return $null
            }
            $output = [PSCredential]::new($user, $(ConvertTo-SecureString -String $this.Password -AsPlainText -Force))
            return $output
        }

    }
    [String]$Description
    [String]$Domain
    # Hidden Properties
    [String]$TreePath
    [String]$Hostname
    [String]$GenericField1
    [String]$GenericField2
    [String]$GenericField3
    [String]$GenericField4
    [String]$GenericField5
    [String]$GenericField6
    [String]$GenericField7
    [String]$GenericField8
    [String]$GenericField9
    [String]$GenericField10
    [System.Array]$GenericFieldInfo
    [Nullable[System.Int32]]$AccountTypeID
    [string]$Notes
    [string]$URL
    [string]$ExpiryDate
    [System.Boolean]$AllowExport
    [string]$AccountType
    [System.Array]$OTP
    # Constructor used to initiate the default property set.
    PasswordResult() {
        [string[]]$DefaultProperties = 'PasswordID', 'Title', 'Username', 'Password', 'Description', 'Domain'

        #Create a propertyset name DefaultDisplayPropertySet, with properties we care about
        $propertyset = New-Object System.Management.Automation.PSPropertySet DefaultDisplayPropertySet, $DefaultProperties
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]$propertyset
        Add-Member -InputObject $this -MemberType MemberSet -Name PSStandardMembers -Value $PSStandardMembers
    }

}

class PasswordResetResult {
    # if password reset is enabled for an object and you want to change the password field your request will be queued (Queued for Reset).
    # Then the returned object from the api is different to the normal password object and we need a new class for this.
    # Properties
    [Nullable[System.Int32]]$PasswordID
    [String]$Status
    $CurrentPassword
    $NewPassword
    [String]GetCurrentPassword() {
        $result = [string]::IsNullOrEmpty($this.CurrentPassword.Password)
        If ($this.CurrentPassword.GetType().Name -ne 'String' -and $result -eq $false) {
            $SecureString = $this.CurrentPassword.Password
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
            return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        }
        Elseif ($this.CurrentPassword.GetType().Name -eq 'String') {
            return $this.CurrentPassword
        }
        Else {
            # input was null so return null
            return $null
        }
    }
    [String]GetNewPassword() {
        $result = [string]::IsNullOrEmpty($this.NewPassword.Password)
        If ($this.NewPassword.GetType().Name -ne 'String' -and $result -eq $false) {
            $SecureString = $this.NewPassword.Password
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
            return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        }
        Elseif ($this.NewPassword.GetType().Name -eq 'String') {
            return $this.NewPassword
        }
        Else {
            # input was null so return null
            return $null
        }
    }
    DecryptPasswords() {
        $this.NewPassword = $this.GetNewPassword()
        $this.CurrentPassword = $this.GetCurrentPassword()
    }
    # Constructor used to initiate the default property set.
    PasswordResult() {
        [string[]]$DefaultProperties = 'PasswordID', 'Status', 'CurrentPassword', 'NewPassword'

        #Create a propertyset name DefaultDisplayPropertySet, with properties we care about
        $propertyset = New-Object System.Management.Automation.PSPropertySet DefaultDisplayPropertySet, $DefaultProperties
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]$propertyset
        Add-Member -InputObject $this -MemberType MemberSet -Name PSStandardMembers -Value $PSStandardMembers
    }
}

class PasswordHistory : PasswordResult {
    $DateChanged
    [String]$USERID
    [String]$FirstName
    [String]$Surname
    [Nullable[System.Int32]]$PasswordHistoryID
    # Constructor used to initiate the default property set.
    PasswordHistory() {
        [string[]]$DefaultProperties = 'PasswordID', 'PasswordHistoryID', 'USERID', 'DateChanged', 'Title', 'Username', 'Password', 'Description', 'Domain'

        #Create a propertyset name DefaultDisplayPropertySet, with properties we care about
        $propertyset = New-Object System.Management.Automation.PSPropertySet DefaultDisplayPropertySet, $DefaultProperties
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]$propertyset
        Add-Member -InputObject $this -MemberType MemberSet -Name PSStandardMembers -Value $PSStandardMembers -Force
    }
}