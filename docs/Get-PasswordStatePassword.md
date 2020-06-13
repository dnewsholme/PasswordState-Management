---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Get-PasswordStatePassword.md
schema: 2.0.0
---

# Get-PasswordStatePassword

## SYNOPSIS
Finds a PasswordState password entry and returns the object.
If multiple matches it will return multiple entries.

## SYNTAX

### General (Default)
```
Get-PasswordStatePassword [[-Search] <String>] [[-PasswordListID] <Int32>] [[-Reason] <String>]
 [-PreventAuditing] [<CommonParameters>]
```

### PasswordID
```
Get-PasswordStatePassword [-PasswordID] <Int32> [[-Reason] <String>] [-PreventAuditing] [<CommonParameters>]
```

### Specific
```
Get-PasswordStatePassword [[-Title] <String>] [[-UserName] <String>] [[-HostName] <String>]
 [[-Domain] <String>] [[-AccountType] <String>] [[-Description] <String>] [[-Notes] <String>] [[-URL] <String>]
 [[-SiteID] <String>] [[-SiteLocation] <String>] [[-GenericField1] <String>] [[-GenericField2] <String>]
 [[-GenericField3] <String>] [[-GenericField4] <String>] [[-GenericField5] <String>]
 [[-GenericField6] <String>] [[-GenericField7] <String>] [[-GenericField8] <String>]
 [[-GenericField9] <String>] [[-GenericField10] <String>] [[-AccountTypeID] <String>] [-PasswordResetEnabled]
 [[-ExpiryDate] <String>] [[-ExpiryDateRange] <String>] [[-AndOr] <String>] [[-PasswordListID] <Int32>]
 [[-Reason] <String>] [-PreventAuditing] [[-ADDomainNetBIOS] <String>] [<CommonParameters>]
```

## DESCRIPTION
Finds a PasswordState password entry and returns the object.
If multiple matches it will return multiple entries.

 There are two ways in which you can search for Passwords via the API, and you can search just within a single Password List, or across all Shared Passwords Lists. The two search methods are:

- Via a **General Search** across the majority of fields in the Passwords table
- Via **Specific Search** criteria, based on fields and values you specify

**General Search**

When performing a **General Search**, it will query the Passwords table for fields which Contain the value you specify for the `-Search` parameter.  
You do not need to specify another parameter than `Search` (Also Search is the first parameter, so you generally do not need to specify the parameter name (`Get-PasswordStatePassword "test123"`)).  
All the fields which will be searched are:

- Title
- ADDomainNetBIOS
- HostName
- UserName
- AccountType
- Description
- GenericField1
- GenericField2
- GenericField3
- GenericField4
- GenericField5
- GenericField6
- GenericField7
- GenericField8
- GenericField9
- GenericField10
- Notes
- URL
- SiteID
- SiteLocation

**Specific Search**

When performing a **Specific Search**, it will query the Passwords table based on one or more of the parameters you specify.  
Just add one of the following parameter to the script execution.  
The fields which can be searched are:

- Title
- HostName
- ADDomainNetBIOS
- UserName
- AccountTypeID
- AccountType
- Description
- GenericField1
- GenericField2
- GenericField3
- GenericField4
- GenericField5
- GenericField6
- GenericField7
- GenericField8
- GenericField9
- GenericField10
- Notes
- URL
- SiteID
- SiteLocation
- PasswordResetEnabled
- ExpiryDate
- ExpiryDateRange
- AndOr

**Note 1**: You can perform an exact match search by enclosing your search criteria in double quotes i.e. '"root_admin"'

**Note 2**: By default, the retrieval of (all) Passwords records will add one Audit record for every Password record returned. If you wish to prevent audit records from being added, you can add the `-PreventAuditing` parameter.

## EXAMPLES

### EXAMPLE 1
```
Get-PasswordStatePassword
```

Returns all password objects the user or api key has access to.

### EXAMPLE 2
```
Get-PasswordStatePassword -PreventAuditing
```

Returns all password objects the user or api key has access to without adding one Audit record for every Password record returned to the audit log.

### EXAMPLE 3
```
Get-PasswordStatePassword -Search "testuser"
```

Returns the object that has the string "testuser" in one of his properties. The password will also be returned.

### EXAMPLE 4
```
Get-PasswordStatePassword -PasswordListID 21
```

Returns all password objects (including password) in password list with ID 21.

### EXAMPLE 5
```
Get-PasswordStatePassword -Title '"testuser"'
```

Returns the objects (including password) that have the string "testuser" in one of his properties. It has to be an exact match with the one of the properties (Requires double quotes for exact match).

### EXAMPLE 6
```
Get-PasswordStatePassword -Title "testuser" -PasswordListID 21
```

Returns the objects (including password) that have the string "testuser" in one of his properties and are located in password list with ID 21.

### EXAMPLE 7
```
Get-PasswordStatePassword -Username "testuser2" -Notes "Test"
```

Returns the object with UserName = testuser2 AND where the notes contain "Test", including password.

### EXAMPLE 8
```
Get-PasswordStatePassword -Username "testuser2" -Notes "Test" -AndOr "OR"
```

Returns the object with UserName = testuser2 OR any object where the notes contain "Test", including password.

### EXAMPLE 9
```
Get-PasswordStatePassword -PasswordID "3456"
```

Returns the object with the PasswordID 3456.

### EXAMPLE 10
```
Get-PasswordStatePassword -PasswordResetEnabled
```

Returns any object where Password resets are enabled.

### EXAMPLE 11
```
Get-PasswordStatePassword -ExpiryDateRange "ExpiryDate>=2012-07-06,ExpiryDate<=2020-12-12"
```

Returns any object where the password will expire between 2012-07-06 and 2020-12-12.

### EXAMPLE 12
```
Get-PasswordStatePassword -ExpiryDate "2020-12-12"
```

Returns any object where the password will expire at 2020-12-12.

### EXAMPLE 13
```
Get-PasswordStatePassword -HostName "SecureComputer.local" -UserName "Administrator" -Reason "Ticket #202005151234567"
```

Returns the password object with UserName "Administrator" and/on HostName "SecureComputer.local". Also specifying the reason "Ticket #202005151234567" why the password object was requested.  
The Reason will be added as audit entry to every password object that will be found with these search criteria.

### EXAMPLE 14
```
Get-PasswordStatePassword -UserName "Administrator" -SiteLocation "Customer1"
```

Returns all password objects with UserName "Administrator" but only from Site "Customer1".

## PARAMETERS

### -AccountType
An optional parameter to filter the search on account type.
The name of the Account Type if one has been chosen for the Password record.  
Account Types and their ID values can be seen on the screen `Administration -> Passwordstate Administration -> Images and Account Types`, and click on the '**Toggle ID Column Visibility**' button to determine the appropriate value. You can also find the AccountType inside the password objects if set.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AccountTypeID
An optional parameter to filter the search on account type by ID.
The ID value representing the Account Type image (derived from the AccountTypes table). An AccountTypeID of 0 (zero) means there is no associated Account Type image for this Password.  
Account Types and their ID values can be seen on the screen `Administration -> Passwordstate Administration -> Images and Account Types`, and click on the '**Toggle ID Column Visibility**' button to determine the appropriate value or on any password record if set.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ADDomainNetBIOS
If you want to search for a record that relates to an Active Directory account, then you can specify the Active Directory NetBIOS value here, as it is stored on the `Administration -> PasswordState Administration -> Active Directory Domains` screen in PasswordState or found in a password record if set.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 28
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AndOr
If parameter is not set, "AND" will be used as default.
As you can build up your query string based on one or more fields/parameters, you can also specify how these queries are joined in the SQL query - either using `-AndOr "OR"`, or `-AndOr "AND"`.

As you'd expect, using the OR operator will return a greater number of results, while the AND operator will return less results as it is a more specific type of query.

```yaml
Type: String
Parameter Sets: Specific
Aliases:
Accepted values: AND, OR

Required: False
Position: 24
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
An optional parameter to filter the search on description.
The description is generally used as a longer verbose description of the nature of the Password object.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Domain
Optionally search for a password object that relates to an Active Directory Account.  
If the password relates to an Active Directory Account, then this record will show the NetBIOS value for the domain.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ExpiryDate
When performing a Specific Search by the `ExpiryDate` field, it will perform an exact match on this value. If you wish to query based on a date range, then please use `-ExpiryDateRange`.  
The `ExpiryDate` is a date in which the password value should be reset for the Password object. The date will be displayed in the format specified for the System Setting option 'Default Locale', through the PasswordState web site interface.

**Note:** Please specify the ExpiryDate in the date format that you have chosen in `'System Settings - miscellaneous - Default Locale'` (Default: '**YYYY-MM-DD**').

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 22
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ExpiryDateRange
Format: `ExpiryDate>=2012-07-14,ExpiryDate<=2020-12-31`

It is possible to specify SQL style query syntax for the ExpiryDateRange parameter, so you can construct a query based on date ranges if needed. Examples of the query syntax you can use is (ensure you separate two dates with a single comma):

- ExpiryDateRange=ExpiryDate>=2012-07-06,ExpiryDate<=2013-01-01
- ExpiryDateRange=ExpiryDate>2012-01-01,ExpiryDate<=2012-02-28
- ExpiryDateRange=ExpiryDate>2013-01-01
- ExpiryDateRange=ExpiryDate<=2012-11-30

**Note**: Dates must be supplied in the `ISO 8601` international standard for date format of **YYYY-MM-DD**.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 23
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField1
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField10
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField2
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField3
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField4
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField5
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField6
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField7
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField8
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GenericField9
An optional parameter to filter the search on a generic field.  
A generic field is a string field which can be renamed to a different value when being displayed in the PasswordState web interface.

**Note**: Generic Fields can be configured as different Field Types, so ensure you pass a valid value for text fields, Select Lists, Radio Buttons or Date Fields.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -HostName
An optional parameter to filter the search on hostname.  
If the record relates to account on a Host, then you can specify the Host Name here to filter for, as it is stored on the Hosts screen in PasswordState.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Notes
An optional parameter to filter the search on notes.  
The Notes field are a generic field where additional descriptive text can be added.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordID
An PasswordID value of the password record in PasswordState to return.

```yaml
Type: Int32
Parameter Sets: PasswordID
Aliases:

Required: True
Position: 0
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordListID
An optional parameter to filter the search on a specific password list.

```yaml
Type: Int32
Parameter Sets: General, Specific
Aliases:

Required: False
Position: 25
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PasswordResetEnabled
Search for all password objects where the password reset is enabled.

```yaml
Type: SwitchParameter
Parameter Sets: Specific
Aliases:

Required: False
Position: 21
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PreventAuditing
By default, the retrieval of (all) Passwords records will add one Audit record for every Password record returned. If you wish to prevent audit records from being added, you can add this `-PreventAuditing` parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 27
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Reason
A reason which can be logged for auditing of why a password was retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 26
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Search
A string value which will be matched with most fields in the database table. Check the description section above fore more information which fields will be used for the search.

```yaml
Type: String
Parameter Sets: General
Aliases:

Required: False
Position: 0
Default value: %
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -SiteID
An optional parameter to filter the search on the site ID.  
If you do not specify this parameter, it will report data based on all Site Locations. Values are 0 for Internal, and all other SiteID's can be found on the screen `Administration -> Remote Site Administration -> Remote Site Locations`.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SiteLocation
An optional parameter to filter the search on the site location.  
If you do not specify this parameter, it will report data based on all Site Locations. Values are the name of the Site Location that can be found on the screen `Administration -> Remote Site Administration -> Remote Site Locations`.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Title
A string value which should match the PasswordState entry.  
A title is a name that describes the nature of the Password object.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -URL
An optional parameter to filter the search on the URL.  
URL parameter can be the URL for HTTP, HTTPS, FTP, SFTP, etc. found in the password object.

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UserName
An optional parameter to filter searches to those with a certain username as multiple titles may have the same value.  
Some systems require a username and password to authenticate. This field represents the UserName to do so.  

```yaml
Type: String
Parameter Sets: Specific
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Int32

### System.Management.Automation.SwitchParameter

### System.Nullable`1[[System.Int32, System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
