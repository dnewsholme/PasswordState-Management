---
external help file: passwordstate-management-help.xml
Module Name: passwordstate-management
online version: https://github.com/dnewsholme/PasswordState-Management/blob/master/docs/Get-PSCustomObject.md
schema: 2.0.0
---

# Get-PSCustomObject

## SYNOPSIS
Sorts an (existing) PSCustomObject

## SYNTAX

```
Get-PSCustomObject [-InputObject] <PSObject> [-Sort] [-Descending] [-Unique] [-CaseSensitive] [-Stable]
 [<CommonParameters>]
```

## DESCRIPTION
Sorts an (existing) PSCustomObject by creating an temporary ordered hashtable and then gets all properties from the given InputObject, sort it by name and add each property to the temporary created ordered hashtable.  
A new PSCustomObject then will receive the sorted properties from the hashtable and the newly created PSCustomObject will the returned from this function.  

## EXAMPLES

### Example 1
```powershell
PS C:\> return $InputObject | Get-PSCustomObject -Sort
```

The PSCustomObject specified with the variable `$InputObject` will be sorted and the returned.

### Example 2
```powershell
PS C:\> return $InputObject | Get-PSCustomObject -Sort:$Sort
```

The PSCustomObject specified with the variable `$InputObject` will be sorted if a switch `$Sort` (best way given as parameter) is found. If `$Sort` is not specified, the PSCustomObject will not be sorted and just returned.

## PARAMETERS

### -CaseSensitive
CaseSensitive sorting

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Descending
Sorting descending

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -InputObject
The InputObject should be a PSCustomObject

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Sort
Sort the given object, if not applied the object will be returned "as it is" (unsorted)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Stable
Stable sorting

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Unique
Sorting by filtering out the duplicates

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
