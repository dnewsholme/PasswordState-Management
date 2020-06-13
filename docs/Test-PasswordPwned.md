---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Test-PasswordPwned.md
schema: 2.0.0
---

# Test-PasswordPwned

## SYNOPSIS
Checks have i been pwned API for if a password has been compromised.

## SYNTAX

```
Test-PasswordPwned [-Value] <String> [<CommonParameters>]
```

## DESCRIPTION
Pwned Passwords overview
Pwned Passwords are more than half a billion passwords which have previously been exposed in data breaches.
The service is detailed in the launch blog post then further expanded on with the release of version 2.
The entire data set is both downloadable and searchable online via the Pwned Passwords page.
It's also queryable via the following two APIs:

Each password is stored as a SHA-1 hash of a UTF-8 encoded password.
The downloadable source data delimits the full SHA-1 hash and the password count with a colon (:) and each line with a CRLF.

Searching by range
In order to protect the value of the source password being searched for, Pwned Passwords also implements a k-Anonymity model that allows a password to be searched for by partial hash.
This allows the first 5 characters of a SHA-1 password hash (not case-sensitive) to be passed to the API (testable by clicking here):

GET https://api.pwnedpasswords.com/range/{first 5 hash chars}
When a password hash with the same first 5 characters is found in the Pwned Passwords repository, the API will respond with an HTTP 200 and include the suffix of every hash beginning with the specified prefix, followed by a count of how many times it appears in the data set.
The API consumer can then search the results of the response for the presence of their source hash and if not found, the password does not exist in the data set.
A sample response for the hash prefix "21BD1" would be as follows:

0018A45C4D1DEF81644B54AB7F969B88D65:1
00D4F6E8FA6EECAD2A3AA415EEC418D38EC:2
011053FD0102E94D6AE2F8B83D76FAF94F6:1
012A7CA357541F0AC487871FEEC1891C49C:2
0136E006E24E7D152139815FB0FC6A50B15:2
...
On average, a range search returns 478 hash suffixes, although this number will differ depending on the hash prefix being searched for.
The smallest result is 381, the largest 584.
There are 1,048,576 different hash prefixes between 00000 and FFFFF (16^5) and every single one will return HTTP 200; there is no circumstance in which the API should return HTTP 404.

## EXAMPLES

### EXAMPLE 1
```
Test-PasswordPwned "qwerty"
```

## PARAMETERS

### -Value
Password value to be checked in plain text string format.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Password

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES
Daryl Newsholme 2018

## RELATED LINKS
