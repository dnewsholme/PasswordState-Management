# PasswordState Management

![PasswordState Logo](https://www.clickstudios.com.au/assets/images/Feature-Block2.png)

## Introduction

Contains various functions for the management of passwordstate via powershell.

## Requirements

| Requirement   | Version |
|---------------|---------|
| passwordstate | 8.0+    |
| Powershell    | 4.0+    |

## How to use

First you will need to setup the environment for PasswordState. This prevents you having to enter the api key all the time as it's stored in an encrypted format. Or you can use Windows authentication using the currently logged on user.

### For API Key

```powershell
    Set-PasswordStateEnvironment  -baseuri "https://passwordstatserver.co.uk" -apikey "dsiwjdi9e0377dw84w45dsw5sw"
```

### For Windows Auth With Pass Through Authentication

```powershell
    Set-PasswordStateEnvironment  -baseuri "https://passwordstateserver.co.uk" -WindowsAuthOnly
```

### For Windows Auth With Custom Credentials

```powershell
    Set-PasswordStateEnvironment  -baseuri "https://passwordstateserver.co.uk" -customcredentials $(Get-Credential)
```

This will save a file called `passwordstate.json` under the users profile folder.

Once the environment has been set up it can be used by other functions.

#### Retrieve a Password

Find and existing password entry and retrieve the password.

```powershell
    Find-PasswordStatePassword -Title "testpassword"
```

Or optionally include the username as well.

```powershell
    Find-PasswordStatePassword -Title "testpassword" -username "someuser"
```

#### Update a password

Update an existing entry with a new password

```powershell
    Update-PasswordStatePassword -Title "testpassword" -PasswordListID 1 -PasswordID 3 -Password "CorrectHorseStapleBattery"
```

Or pipe in the result from finding one.

```powershell
    Find-PasswordStatePassword -Title "testpassword" | Update-PasswordStatePassword -password "CorrectHorseStapleBattery"
```

#### Create a New Password Entry

Create a new password entry.

```powershell
    New-PasswordStatePassword -Title "testpassword" -PasswordListID 1 -username "newuser" -Password "CorrectHorseStapleBattery" -notes "development website" -url "http://somegoodwebsite.com"
```

Create a new entry to a PasswordList if you know the name of the list.

```powershell
    Get-PasswordStateLists | ? {$_.PasswordList -eq "passwordlistname"} | New-PasswordStatePassword -Title "testpassword" -username "newuser" -Password "CorrectHorseStapleBattery" -notes "development website" -url "http://somegoodwebsite.com"
```

#### Get All Password Lists

Useful to return the `listID` for use in other commands such as creating a new entry.

**NOTE: due to an api limitation when using APIKeys only the system key can return lists** This is not an issue using Windows Authentication.

```powershell
    Get-PasswordStateLists
```

#### Deleting a password entry

Deletes an existing password entry.

```powershell
    Remove-PasswordStatePassword -passwordID 5 -SendToRecycleBin
```

Or find the password and pipe it acrosss to remove.

```powershell
   Find-PasswordStatePassword -title "testuser" | Remove-PasswordStatePassword -SendToRecycleBin
```

##### Additional Info

Functions all contain Pester tests with mocked data to ensure no changes are made to the environment but ensuring that the code works.

Full documentation under `.\docs` 