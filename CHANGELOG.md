# Changelog

## 4.1.0

+ Added support for updating genericfields on existing passwords with Update-PasswordStatePassword.

## 4.0.0

+ Removed the function ConvertTo-PScredential and replaced with a method on the Password returned. Use .ToPSCredential() to convert.

## 3.1.0

+ Added new functions for managing hosts within PasswordState Get-PasswordstateHost, New-PassswordStateHost and Remove-PasswordStateHost.Thanks [Colombeen](https://github.com/colombeen)

## 3.0.0

+ Breaking change. Merged Find-PasswordstatePassword and Get-PassswordStatePasswords into Get-PasswordStatePassword with the functionality of both. Find-PasswordstatePassword is Aliased to Get-PasswordstatePassword.

## 2.3.0

+ Added support for preventing audit records being written.

## 2.2.0

+ Performance improvements to Find-PasswordStatePassword.

## 2.1.0

+ Added extra parameters for Get-PasswordStateFolder. Thanks [Colombeen](https://github.com/colombeen)

## 2.0.0

+ Breaking Change. Get-PasswordstateList parameters have changed to be more consistent with the rest of the module. Thanks [Colombeen](https://github.com/colombeen)

## 1.1.0

+ Added support to search a particular list only with Find-Passwordstatepassword. Thanks [Colombeen](https://github.com/colombeen)

## 1.0.1

+ Changed output of default properties for \[PasswordResult\] typed items.

## 0.0.105

+ Allow password generation using PasswordPolicyID's from New-RandomPassword. Thanks [Colombeen](https://github.com/colombeen)

## 0.0.101

+ Allow generation of password when creating a new password and fixes issue with casting blank passwords to the \[PasswordResult\] type.

## 0.0.98

+ Fix for get-Passwordstatepasswords not correctly casting to secure type.

## 0.0.97

+ Added initial support for linux with fix for kerberos auth on winapi.

## 0.0.95

+ Feature
  + New cmdlet ConvertTO-PSCredential which will convert password state entry to powershell credential object. Thanks [Colombeen](https://github.com/colombeen)

+ Fixes
  + Fixed issue when calling .GetPassword() against and already decrypted password. Thanks [Colombeen](https://github.com/colombeen)

## 0.0.94

+ Feature
  + Passwords now returned as secure string. Use .GetPassword() method to retrieve plaintext
  + Global variable for returning plain text passwords $global:PasswordStateShowPasswordsPlainText = $true
+ Fixes
  + Added support for APIKey auth to generate passwords as this was broken.
  + Various bugfixes when using apikeys.

## 0.0.91

+ Fix
  + Search across multiple fields. Thanks [Colombeen](https://github.com/colombeen)

## 0.0.89

+ Fix
  + Search by title now correctly searches across title field only instead of all fields. A New parameter called searchterm has been created to replicate the old search and made the default first parameter to replicate the old use.

## 0.0.85

+ Fix
  + Fix for searching for entries by username only.

## 0.0.80

+ Feature
  + Return all passwords for a particular list with Get-PasswordStatePasswords, and allow setting of customproperties on new passwords. Thanks [2dman](https://github.com/2Dman)

## 0.0.77

+ Fix
  + Update module manifest.

## 0.0.76

+ Fix
  + Update module manifest.

## 0.0.75

+ Fix
  + Prevent update-passwordstatepassword trying to add verbose as a property.

## 0.0.74

+ Fix
  + Allow Update-PasswordStatePassword to accept pipeline input for new fields.

## 0.0.73

+ Feature
  + Allow Update-PasswordStatePassword to update all fields of the entry not just the password.

## 0.0.69**

+ Feature
  + limit the information displayed from find-passwordstatepassword #2.

## 0.0.68

+ Fix
  + Issue with generating random passwords.