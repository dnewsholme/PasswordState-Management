---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/New-PasswordStatePassword.md
schema: 2.0.0
---

# New-PasswordStatePassword

## SYNOPSIS
Creates a New Password State Password entry in the specified password list.

## SYNTAX

### All (Default)
```
New-PasswordStatePassword [-PasswordListID] <Int32> [-Title] <String> [[-Username] <String>]
 [[-Description] <String>] [[-Notes] <String>] [[-Url] <String>] [[-AccountType] <String>]
 [[-AccountTypeID] <Int32>] [[-GenericField1] <String>] [[-GenericField2] <String>] [[-GenericField3] <String>]
 [[-GenericField4] <String>] [[-GenericField5] <String>] [[-GenericField6] <String>]
 [[-GenericField7] <String>] [[-GenericField8] <String>] [[-GenericField9] <String>]
 [[-GenericField10] <String>] [-GenerateGenFieldPassword] [[-AddDaysToExpiryDate] <Int32>]
 [[-ScriptID] <Int32>] [[-PrivilegedAccountID] <Int32>] [[-HostName] <String>] [[-ADDomainNetBIOS] <String>]
 [[-ExpiryDate] <String>] [-AllowExport] [[-WebUser_ID] <String>] [[-WebPassword_ID] <String>]
 [-SkipExistenceCheck] [[-Reason] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### HeartbeatSchedule
```
New-PasswordStatePassword [-PasswordListID] <Int32> [-Title] <String> [[-Username] <String>]
 [[-Password] <String>] [[-Description] <String>] [-GeneratePassword] [[-Notes] <String>] [[-Url] <String>]
 [[-AccountType] <String>] [[-AccountTypeID] <Int32>] [[-GenericField1] <String>] [[-GenericField2] <String>]
 [[-GenericField3] <String>] [[-GenericField4] <String>] [[-GenericField5] <String>]
 [[-GenericField6] <String>] [[-GenericField7] <String>] [[-GenericField8] <String>]
 [[-GenericField9] <String>] [[-GenericField10] <String>] [-GenerateGenFieldPassword]
 [[-AddDaysToExpiryDate] <Int32>] [[-ScriptID] <Int32>] [[-PrivilegedAccountID] <Int32>]
 [-HeartbeatSchedule] <String> [[-HostName] <String>] [[-ADDomainNetBIOS] <String>] [[-ExpiryDate] <String>]
 [-AllowExport] [[-WebUser_ID] <String>] [[-WebPassword_ID] <String>] [-SkipExistenceCheck]
 [[-Reason] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Heartbeat
```
New-PasswordStatePassword [-PasswordListID] <Int32> [-Title] <String> [[-Username] <String>]
 [[-Password] <String>] [[-Description] <String>] [-GeneratePassword] [[-Notes] <String>] [[-Url] <String>]
 [[-AccountType] <String>] [[-AccountTypeID] <Int32>] [[-GenericField1] <String>] [[-GenericField2] <String>]
 [[-GenericField3] <String>] [[-GenericField4] <String>] [[-GenericField5] <String>]
 [[-GenericField6] <String>] [[-GenericField7] <String>] [[-GenericField8] <String>]
 [[-GenericField9] <String>] [[-GenericField10] <String>] [-GenerateGenFieldPassword]
 [[-AddDaysToExpiryDate] <Int32>] [[-ScriptID] <Int32>] [[-PrivilegedAccountID] <Int32>] [-HeartbeatEnabled]
 [[-HeartbeatSchedule] <String>] [-ValidationScriptID] <Int32> [[-HostName] <String>]
 [[-ADDomainNetBIOS] <String>] [-ValidateWithPrivAccount] [[-ExpiryDate] <String>] [-AllowExport]
 [[-WebUser_ID] <String>] [[-WebPassword_ID] <String>] [-SkipExistenceCheck] [[-Reason] <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Reset
```
New-PasswordStatePassword [-PasswordListID] <Int32> [-Title] <String> [[-Username] <String>]
 [[-Password] <String>] [[-Description] <String>] [-GeneratePassword] [[-Notes] <String>] [[-Url] <String>]
 [[-AccountType] <String>] [[-AccountTypeID] <Int32>] [[-GenericField1] <String>] [[-GenericField2] <String>]
 [[-GenericField3] <String>] [[-GenericField4] <String>] [[-GenericField5] <String>]
 [[-GenericField6] <String>] [[-GenericField7] <String>] [[-GenericField8] <String>]
 [[-GenericField9] <String>] [[-GenericField10] <String>] [-GenerateGenFieldPassword] [-PasswordResetEnabled]
 [-EnablePasswordResetSchedule] [[-PasswordResetSchedule] <String>] [[-AddDaysToExpiryDate] <Int32>]
 [[-ScriptID] <Int32>] [[-PrivilegedAccountID] <Int32>] [-HeartbeatEnabled] [[-HeartbeatSchedule] <String>]
 [[-ValidationScriptID] <Int32>] [[-HostName] <String>] [[-ADDomainNetBIOS] <String>]
 [-ValidateWithPrivAccount] [[-ExpiryDate] <String>] [-AllowExport] [[-WebUser_ID] <String>]
 [[-WebPassword_ID] <String>] [-SkipExistenceCheck] [[-Reason] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ResetSchedule
```
New-PasswordStatePassword [-PasswordListID] <Int32> [-Title] <String> [[-Username] <String>]
 [[-Password] <String>] [[-Description] <String>] [-GeneratePassword] [[-Notes] <String>] [[-Url] <String>]
 [[-AccountType] <String>] [[-AccountTypeID] <Int32>] [[-GenericField1] <String>] [[-GenericField2] <String>]
 [[-GenericField3] <String>] [[-GenericField4] <String>] [[-GenericField5] <String>]
 [[-GenericField6] <String>] [[-GenericField7] <String>] [[-GenericField8] <String>]
 [[-GenericField9] <String>] [[-GenericField10] <String>] [-GenerateGenFieldPassword]
 [-EnablePasswordResetSchedule] [-PasswordResetSchedule] <String> [[-AddDaysToExpiryDate] <Int32>]
 [[-ScriptID] <Int32>] [[-PrivilegedAccountID] <Int32>] [-HeartbeatEnabled] [[-HeartbeatSchedule] <String>]
 [[-ValidationScriptID] <Int32>] [[-HostName] <String>] [[-ADDomainNetBIOS] <String>]
 [-ValidateWithPrivAccount] [[-ExpiryDate] <String>] [-AllowExport] [[-WebUser_ID] <String>]
 [[-WebPassword_ID] <String>] [-SkipExistenceCheck] [[-Reason] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Password
```
New-PasswordStatePassword [-PasswordListID] <Int32> [-Title] <String> [[-Username] <String>]
 [-Password] <String> [[-Description] <String>] [[-Notes] <String>] [[-Url] <String>] [[-AccountType] <String>]
 [[-AccountTypeID] <Int32>] [[-GenericField1] <String>] [[-GenericField2] <String>] [[-GenericField3] <String>]
 [[-GenericField4] <String>] [[-GenericField5] <String>] [[-GenericField6] <String>]
 [[-GenericField7] <String>] [[-GenericField8] <String>] [[-GenericField9] <String>]
 [[-GenericField10] <String>] [-GenerateGenFieldPassword] [[-AddDaysToExpiryDate] <Int32>]
 [[-ScriptID] <Int32>] [[-PrivilegedAccountID] <Int32>] [[-HostName] <String>] [[-ADDomainNetBIOS] <String>]
 [[-ExpiryDate] <String>] [-AllowExport] [[-WebUser_ID] <String>] [[-WebPassword_ID] <String>]
 [-SkipExistenceCheck] [[-Reason] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### GeneratePassword
```
New-PasswordStatePassword [-PasswordListID] <Int32> [-Title] <String> [[-Username] <String>]
 [[-Description] <String>] [-GeneratePassword] [[-Notes] <String>] [[-Url] <String>] [[-AccountType] <String>]
 [[-AccountTypeID] <Int32>] [[-GenericField1] <String>] [[-GenericField2] <String>] [[-GenericField3] <String>]
 [[-GenericField4] <String>] [[-GenericField5] <String>] [[-GenericField6] <String>]
 [[-GenericField7] <String>] [[-GenericField8] <String>] [[-GenericField9] <String>]
 [[-GenericField10] <String>] [-GenerateGenFieldPassword] [[-AddDaysToExpiryDate] <Int32>]
 [[-ScriptID] <Int32>] [[-PrivilegedAccountID] <Int32>] [[-HostName] <String>] [[-ADDomainNetBIOS] <String>]
 [[-ExpiryDate] <String>] [-AllowExport] [[-WebUser_ID] <String>] [[-WebPassword_ID] <String>]
 [-SkipExistenceCheck] [[-Reason] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a New Password State Password entry in the specified password list.

## EXAMPLES

### EXAMPLE 1
```
New-PasswordStatePassword -Title "testpassword" -PasswordListID 1 -Username "newuser" -Password "CorrectHorseStapleBattery" -Notes "development website" -Url "http://somegoodwebsite.com" -GenericField1 'value for GenericField1' -GenericField2 'value2'
```

Creates a new password entry called testpassword with some options and values for two GenericFields

### EXAMPLE 2
```
New-PasswordStatePassword -Title "testpassword" -PasswordListID 1 -Username "newuser" -GeneratePassword -AccountTypeID 64 -Notes "development website" -Description 'Test Account' -Url "http://somegoodwebsite.com" -GenericField1 'value for GenericField1' -GenericField2 'value2'
```

Creates a new password entry called testpassword with AccountType 64 (Active Directory) and some other options. A random password will be generated.

### EXAMPLE 3
```
New-PasswordStatePassword -PasswordListID 1 -Title "testpassword" -Username "newuser" -GeneratePassword -AccountTypeID 13 -PasswordResetEnabled -EnablePasswordResetSchedule -PasswordResetSchedule "23:00" -ScriptID 7 -PrivilegedAccountID 1 -HostName "testhost"
```

Creates a new password entry with AccountType 13 (Windows User) enabled password reset (only working if password reset is also enabled on the password list). The Password Reset Schedule will be set to daily 23:00 (11:00 pm). The script with ID 7 (Reset Windows Password) and the Privileged User Account with ID 1 will be used for reset. The reset will be targeted to host "testhost".

### EXAMPLE 4
```
New-PasswordStatePassword -PasswordListID 1 -Title "testpassword" -Username "newuser" -GeneratePassword -AccountTypeID 13 -PasswordResetEnabled -EnablePasswordResetSchedule -PasswordResetSchedule "23:00" -ScriptID 7 -PrivilegedAccountID 1 -HostName "testhost"
```

Creates a new password entry with AccountType 13 (Windows User) enabled password reset (only working if password reset is also enabled on the password list). The Password Reset Schedule will be set to daily 23:00 (11:00 pm). The script with ID 7 (Reset Windows Password) and the Privileged User Account with ID 1 will be used for reset. The reset will be targeted to host "testhost".

### EXAMPLE 5
```
New-PasswordStatePassword -PasswordListID 1 -Title "testpassword" -Username "newuser" -GeneratePassword -AccountTypeID 64 -PasswordResetEnabled -EnablePasswordResetSchedule -PasswordResetSchedule "23:00" -PrivilegedAccountID 1 -ADDomainNetBIOS "testdomain.local"
```

Creates a new password entry with AccountType 64 (Active Directory User) enabled password reset (only working if password reset is also enabled on the password list). The Password Reset Schedule will be set to daily 23:00 (11:00 pm). No script needed, so active directory account is selected. The Privileged User Account with ID 1 will be used for reset. The reset will be targeted to active directory domain (net bios name) "testdomain.local".

### EXAMPLE 6
```
New-PasswordStatePassword -PasswordListID 1 -Title "testpassword" -Username "newuser" -GeneratePassword -AccountTypeID 61 -PasswordResetEnabled -EnablePasswordResetSchedule -PasswordResetSchedule "23:00" -HeartbeatEnabled -HeartbeatSchedule "21:00" -PrivilegedAccountID 2 -ValidationScriptID 2 -ValidateWithPrivAccount -HostName "testhost2"
```

Creates a new password entry with AccountType 61 (Ubuntu) enabled password reset (only working if password reset is also enabled on the password list). The Password Reset Schedule will be set to daily 23:00 (11:00 pm). The script with ID 3 (Reset Linux Password) will be used. The Privileged User Account with ID 2 will be used for reset. The reset will be targeted to host "testhost2". Also account heartbeat will be enabled and set to daily 21:00 (09:00 pm). Due to -ValidateWithPrivAccount switch, the same account as specified for the reset will be used for validation. We are using Validation Script ID 2 (Linux Account).

## PARAMETERS

### -AccountType
The name of the Account Type if one has been chosen for the Password record.  
You can either specify the AccountType or AccountTypeID if needed when adding password records. Account Types and their ID values can be seen on the screen `Administration -> Passwordstate Administration -> Images and Account Types`, and click on the '**Toggle ID Column Visibility**' button to determine the appropriate value.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AccountTypeID
The ID value representing the Account Type image (derived from the AccountTypes table). An AccountTypeID of 0 (zero) means there is no associated Account Type image for this Password.  
You can either specify the AccountType or AccountTypeID if needed when adding password records. Account Types and their ID values can be seen on the screen `Administration -> Passwordstate Administration -> Images and Account Types`, and click on the '**Toggle ID Column Visibility**' button to determine the appropriate value.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AddDaysToExpiryDate
Once the password has been changed due to a scheduled reset, you can add an additional (x) number of days to the ExpiryDate field so another reset will occur again in 30, 60, 90 days, etc. This is the option on the Reset Options tab for the record.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ADDomainNetBIOS
If the record relates to an Active Directory account, then you must specify the Active Directory NetBIOS value here, as it is stored on the `Administration -> PasswordState Administration -> Active Directory Domains` screen in PasswordState.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowExport
Indicates whether this Password object will be exported when the entire Password List contents are exported.  
Only working if "Allow Password List to be Exported" is set on the password list.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 25
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
Custom description to be added to the password.  
Can be used as a longer verbose description of the nature of the Password object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnablePasswordResetSchedule
If you want to specify a regular scheduled for automatically resetting the value of the Password, you need to enable this option.

```yaml
Type: SwitchParameter
Parameter Sets: Reset
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: ResetSchedule
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ExpiryDate
The date in which the password value should be reset for this Password object. The date will be displayed in the **format** specified for the `System Setting option 'Default Locale'`, through the PasswordState web site interface.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 24
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenerateGenFieldPassword
If set to true, any '**Generic Fields**' which you have set to be of **type 'Password**' will have a newly generated random password assigned to it. If the Password List or Generic Field is set to use the user's Password Generator options, the Default Password Generator options will be used instead.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GeneratePassword
A switch parameter to generate the password based of the PasswordList Policy.  
A newly generated random password will be created based on the Password Generator options associated with the Password List. If the Password List is set to use the user's Password Generator options, the Default Password Generator options will be used instead.

```yaml
Type: SwitchParameter
Parameter Sets: HeartbeatSchedule, Heartbeat, Reset, ResetSchedule
Aliases:

Required: False
Position: 10
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: GeneratePassword
Aliases:

Required: True
Position: 10
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField1
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField10
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField2
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField3
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField4
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField5
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField6
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField7
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField8
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField9
A generic string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -HeartbeatEnabled
If you want to enable the record to perform regular account heartbeat status update apply this switch.

```yaml
Type: SwitchParameter
Parameter Sets: Heartbeat
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: Reset, ResetSchedule
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -HeartbeatSchedule
This field allows you to set the schedule for the account heartbeat status update. Specify values in the format of 23:10, or 04:00, etc. (Range: 00:00-23:59)

```yaml
Type: String
Parameter Sets: HeartbeatSchedule
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Heartbeat, Reset, ResetSchedule
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -HostName
If the record relates to account on a Host, then you must specify the Host Name here, as it is stored on the Hosts screen in PasswordState.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
A generic Notes field where additional descriptive text can be added.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Password
The password to be added to the entry (stored as encrypted binary field in database).

```yaml
Type: String
Parameter Sets: HeartbeatSchedule, Heartbeat, Reset, ResetSchedule
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Password
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordListID
The unique ID of the password list which to place the entry in.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordResetEnabled
This option will enable the account to perform Password Resets. To do this, the Password List the password record belongs to, must also have this option set.

```yaml
Type: SwitchParameter
Parameter Sets: Reset
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordResetSchedule
This field allows you to set the schedule for automatic password changes. Specify values in the format of 23:10, or 04:00, etc. (Range: 00:00 - 23:59)

```yaml
Type: String
Parameter Sets: Reset
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ResetSchedule
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PrivilegedAccountID
Some Password Reset Scripts also require a `Privileged Account Credential` to be associated with the Password record, to initiate connection and perform the reset. Requirements for Privileged Accounts are documented in the User Manual, under the KB Article section. To look up the value of PrivilegedAccountID's, this can be done on the screen `Administration -> PasswordState Administration -> Privileged Account Credentials`.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 23
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Reason
A reason which can be logged for auditing of why a password was updated.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 27
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ScriptID
Most accounts require a Password Reset Script to be assigned to them, with the only exception being Active Directory Accounts - not to specify this field for AD Accounts. To look up the values of the ScriptID's, this can be done by using the '**Toggle ID Column Visibility**' button on the Password Reset Scripts screens in PasswordState.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SkipExistenceCheck
If applied, the script will skip the check if the password entry is already existing. For the check the script uses the Title and Username field. Sometimes it is possible that the Username and Title field should have the same values, then please apply -SkipExistenceCheck.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 26
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Title
Name of the entry to be created.  
A title to describe the nature of the Password object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Url
URL parameter where you can specify the URL for HTTP, HTTPS, FTP, SFTP, etc. to be added to the entry if relevant.  

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Username
The username to be added to the entry (Optional).  
Some systems require a username and password to authenticate. This field represents the UserName to do so.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ValidateWithPrivAccount
This field is only used for **Linux accounts**, and when set to True, the Privileged Account Credential will be used for Authentication when performing Account Heartbeats - useful for accounts like root which generally are not allowed to be used for SSH.

```yaml
Type: SwitchParameter
Parameter Sets: Heartbeat, Reset, ResetSchedule
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ValidationScriptID
When enabling Account Heartbeat, you must associate the correct Password Validation Script to the record (all account types require a Validation Script to be selected). To look up the values of the ValidationScriptID's, this can be done by using the '**Toggle ID Column Visibility**' button on the Password Validation Scripts screens in PasswordState.

```yaml
Type: Int32
Parameter Sets: Heartbeat
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: Reset, ResetSchedule
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WebPassword_ID
This field is only used in conjunction with the Browser Extensions, and represents the Password field for login pages i.e. the tag name of the Input HTML field.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 25
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WebUser_ID
This field is only used in conjunction with the Browser Extensions, and represents the Username field for login pages i.e. the tag name of the Input HTML field.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 25
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Nullable`1[[System.Int32, System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]]

### System.String

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
