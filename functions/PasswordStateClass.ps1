[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Script is converting to secure string.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Script is converting to secure string.')]
# Create Class
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
    [int]$PasswordID
    [String]$Title
    [int]$PasswordListID
    [String]$Passwordlist
    [String]$Username
    $Password
    [String]GetPassword() {
        $result = [string]::IsNullOrEmpty($this.Password.Password)
        If ($this.Password.GetType().Name -ne 'String' -and $result -eq $false) {
            $SecureString = $this.Password.Password
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
            return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        }
        if ($result -eq $true) {
            return $null
        }
        Else {
            return $this.Password
        }
    }
    DecryptPassword() {
        $this.Password = $this.GetPassword()
    }
    [PSCredential]ToPSCredential() {
        $user = ''
        If (-not ([String]::IsNullOrEmpty($this.Domain)))
        {
          $user += "$($this.Domain)\"
        }
        $user += "$($this.Username)"
        $result = [String]::IsNullOrEmpty($this.Password.Password)
        If ($this.Password.GetType().Name -ne 'String' -and $result -eq $false) {
            $output = [PSCredential]::new($user, $this.Password.Password)
            return $output
        }
        if ($result -eq $true) {
            return $null
        }
        Else {
            $this.Password = [EncryptedPassword]$this.Password
            $output = [PSCredential]::new($user, $this.Password.Password)
            return $output
        }
    }
    [String]$Description
    [String]$Domain
    # Hidden Properties
    [String]$TreePath
    [String]$hostname
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
    [int]$AccountTypeID
    [string]$notes
    [string]$URL
    [string]$ExpiryDate
    [string]$allowExport
    [string]$accounttype
    # Constructor used to initiate the default property set.
    PasswordResult() {
        [string[]]$DefaultProperties = 'PasswordID', 'Title', 'Username', 'Password', 'Description', 'Domain'

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
    [int32]$PasswordHistoryID
    # Constructor used to initiate the default property set.
    PasswordHistory() {
        [string[]]$DefaultProperties = 'PasswordID', 'PasswordHistoryID', 'USERID', 'DateChanged', 'Title', 'Username', 'Password', 'Description', 'Domain'

        #Create a propertyset name DefaultDisplayPropertySet, with properties we care about
        $propertyset = New-Object System.Management.Automation.PSPropertySet DefaultDisplayPropertySet, $DefaultProperties
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]$propertyset
        Add-Member -InputObject $this -MemberType MemberSet -Name PSStandardMembers -Value $PSStandardMembers -Force
    }
}