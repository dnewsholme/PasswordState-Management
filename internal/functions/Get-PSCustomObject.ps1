function Get-PSCustomObject {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory = $true)]
        [PSCustomObject]$InputObject,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory = $false)]
        [switch]$Sort,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory = $false)]
        [switch]$Descending,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory = $false)]
        [switch]$Unique,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory = $false)]
        [switch]$CaseSensitive,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory = $false)]
        [switch]$Stable
    )
    process {
        if ($Sort) {
            # Create a temporary new ordered hashtable
            $ObjectSorted = [ordered]@{ }
            # Get all properties from the given InputObject, sort it by name and add each property to the temporary created ordered hashtable
            Get-Member -Type NoteProperty -InputObject $InputObject | Sort-Object -Unique:$Unique -Descending:$Descending -CaseSensitive:$CaseSensitive -Stable:$Stable -Property Name | ForEach-Object { $ObjectSorted[$_.Name] = $InputObject.$($_.Name) }
            # Create a new PSCustomObject that will receive the sorted properties from the hashtable
            $OutputObject = New-Object PSCustomObject
            # Add each property the the newly created PSCustomObject
            Add-Member -InputObject $OutputObject -NotePropertyMembers $ObjectSorted

            # return the sorted object
            return $OutputObject
        }
        else {
            return $InputObject
        }
    }
}