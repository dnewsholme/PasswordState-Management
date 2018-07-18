---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version:
schema: 2.0.0
---

# New-PasswordStateList

## SYNOPSIS
Creates a passwordstate List.

## SYNTAX

```
New-PasswordStateList [-Name] <Object> [-description] <Object> [[-CopySettingsFromPasswordListID] <Object>]
 [-FolderID] <Object> [<CommonParameters>]
```

## DESCRIPTION
Creates a passwordstate List.

## EXAMPLES

### EXAMPLE 1
```
New-PasswordStateList -Name TestList -Description "A Test List" -FolderID 4
```

## PARAMETERS

### -Name
Name of the Passwordstate list

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -description
Description fro the list

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CopySettingsFromPasswordListID
Optionally copy the settings from another list.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FolderID
Folder ID that the list should be placed under

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Daryl Newsholme 2018

## RELATED LINKS
