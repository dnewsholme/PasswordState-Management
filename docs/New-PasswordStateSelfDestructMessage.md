---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/New-PasswordStateSelfDestructMessage.md
schema: 2.0.0
---

# New-PasswordStateSelfDestructMessage

## SYNOPSIS
Sending Self Destruct Messages via the API.

## SYNTAX

```
New-PasswordStateSelfDestructMessage [[-PasswordID] <Int32>] [[-Message] <String>]
 [[-PrefixMessageContent] <String>] [[-AppendMessageContent] <String>] [[-ExpiresAt] <String>]
 [[-NoViews] <Int32>] [-ToEmailAddress] <String> [[-ToFirstName] <String>] [[-EmailSubject] <String>]
 [[-EmailBody] <String>] [[-Passphrase] <String>] [[-Reason] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Sending Self Destruct Messages via the API.

To send Self Destruct Messages, you must have access to the following features within PasswordState:

- When sending messages based on a Password record - your account must have access this Password record.
- When sending a message that is not related to a Password record i.e. free-form message body - you must have access to the '`Self Destruct Message`' **menu** in PasswordState.

With the email the recipient receives for the Self Destruct message, you can either use the supplied **Email Template** '`Self Destruct Message Email`' found on the screen `Administration -> Email Templates`, or you can specify the entire body of the message yourself.

**Note 1**: **Never** send the passphrase + url in the same self destruct message!

## EXAMPLES

### Example 1
```powershell
PS C:\> New-PasswordStateSelfDestructMessage -ToEmailAddress "surname.lastname@example.com" -PasswordID 114
```

Sending a self destruct message for PasswordID 114 to the desired recipient. The url is not restricted and can be accessed by anyone that has the url/email. The default values for `ExpiresAt` and `NoViews` will be used.

### Example 2
```powershell
PS C:\> New-PasswordStateSelfDestructMessage -ToEmailAddress "surname.lastname@example.com" -PasswordID 114 -Passphrase "API=Cool" -Reason "This is a cool reason" -EmailSubject "Highly Secure" -PrefixMessageContent "<br>Only for your eyes</br>"
```

Sending a self destruct message for PasswordID 114 to the desired recipient. The url is restricted and can be accessed with the defined Passphrase. A audit log entry with the Reason will be created. The Email will be send with the given Subject and the default Self Destruct Email Template will be used. The default values for `ExpiresAt` and `NoViews` will be used.  
After opening the url, a PrefixMessage will be displayed above the Password Details.

### Example 3
```powershell
PS C:\> New-PasswordStateSelfDestructMessage -ToEmailAddress "surname.lastname@example.com" -PasswordID 114 -Passphrase "API=Cool" -Reason "This is a cool reason" -EmailSubject "Highly Secure" -ToFirstName "surname.lastname" -PrefixMessageContent "<br>Only for your eyes</br>" -EmailBody "Hello [ToFirstName],
         <p> A secure message was sent to you from <a href=""https://passwordstate.local/"">PasswordState Passwordmanager</a><br>
         <p> These message was triggered by [UserName]. <br> Please check the following link: [URL].<br>
         <p> You have [ExpirePeriod] until the message will be expire.<br>
         <p> Please enter the Passphrase you got from [UserName] after opening the website.<br>
         <br>
         </p>"
```

Sending a self destruct message for PasswordID 114 to the desired recipient. The url is restricted and can be accessed with the defined Passphrase. A audit log entry with the Reason will be created.  
The Email will be send with the given Subject and the HTML email body specified will be used as email text. ToFirstName is needed for the email body variable `[ToFirstName]`.  
After opening the url, a PrefixMessage will be displayed above the Password Details.  
 The default values for `ExpiresAt` and `NoViews` will be used.

## PARAMETERS

### -AppendMessageContent
If you are sending a message based of a password record, you can append information after the password record details with content from this field - HTML tags can be used if required.

**Note 1:** All diacritics, german umlauts and other invalid characters that the api does not understand will be converted from the given string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EmailBody
If left blank, the Email Template '`Self Destruct Message Email`' will be used, but you can use this field to specify the entire Email Body if you wish - HTML tags can be used if required.

There are also certain variables in the EmailBody that will be replaced as appropriate, when the email is sent - and they are:

- `[ToFirstName]`
  - the First Name of the recipient who will receive the email
  - You need to specify the `-ToFirstName` parameter
- `[UserName]`
  - this is the FirstName and Surname of the user sending the Self Destruct Message
- `[ExpirePeriod]`
  - How long the message will be alive until it is automatically deleted
  - You need to specify the `-ExpiresAt` parameter
- `[URL]`
  - This is the URL for the recipient to click on to view the Self Destruct Message
- `[Version]`
  - The Version Number for your PasswordState instance
- `[SiteURL]`
  - The URL of your PasswordState instance

**Note 1:** All diacritics, german umlauts and other invalid characters that the api does not understand will be converted from the given string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EmailSubject
The Subject Line of the email sent to the recipient - if not specified, the Subject will be used from the Email Template '`Self Destruct Message Email`'

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

### -ExpiresAt
This is the duration for how long the self destruct message exists before it is deleted due to not being viewed.  
You specify the duration and time period for this field, as per the following examples `30m (30 minutes), 3h (3 hours), or 2d (2 days)`.

Defaults to `1d`.

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

### -Message
Use this field is you are wanting to specify the entire Self Destruct Message yourself, instead of it being based off of a password record - HTML tags can be used if required.

**Note 1:** All diacritics, german umlauts and other invalid characters that the api does not understand will be converted from the given string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NoViews
How many times the Self Destruct Message can be viewed, before it is removed.

Defaults to `1`.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Passphrase
If you would like to Passphrase protect the Self Destruct Message, you can use this field to do that - the recipient must know the Passphrase in order to read the message.

**Note 1**: **Never** send the passphrase + url in the same self destruct message!

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

### -PasswordID
The PasswordID value of the password record you are sending a Self Destruct Message for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PrefixMessageContent
If you are sending a message based off of a password record, you can prefix information before the password record details with content from this field - HTML tags can be used if required.

**Note 1:** All diacritics, german umlauts and other invalid characters that the api does not understand will be converted from the given string.

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

### -Reason
You can specify a Reason for sending this Self Destruct Message, and it will be added to the appropriate auditing data.

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

### -ToEmailAddress
The Email Address of the recipient who is to receive the Self Destruct Message.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ToFirstName
The First Name of the recipient who is to receive the Self Destruct Message - this is used in the email which is sent to the recipient}

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

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
