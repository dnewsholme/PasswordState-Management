function New-PasswordStateDependency {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingPlainTextForPassword', '', Justification = 'Not a password field.'
    )]
    [cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'General')]
    param (
        [parameter(ParameterSetName = 'Dependency', ValueFromPipelineByPropertyName, Position = 0, Mandatory = $false)]
        [ValidateSet('Windows Service', 'IIS Application Pool', 'Scheduled Tasks', 'COM+ Component')]
        [string]$DependencyType,
        [parameter(ParameterSetName = 'Dependency', ValueFromPipelineByPropertyName, Position = 1, Mandatory = $false)]
        [string]$DependencyName,
        [parameter(ParameterSetName = 'Host', ValueFromPipelineByPropertyName, Position = 0, Mandatory = $false)]
        [string]$HostName,
        [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 0, Mandatory = $true)]
        [parameter(ParameterSetName = 'Host', ValueFromPipelineByPropertyName, Position = 1, Mandatory = $true)]
        [parameter(ParameterSetName = 'Dependency', ValueFromPipelineByPropertyName, Position = 2, Mandatory = $true)]
        [int32]$PasswordID,
        [Parameter(ParameterSetName = 'General', ValueFromPipelineByPropertyName, Position = 1, Mandatory = $true)]
        [parameter(ParameterSetName = 'Host', ValueFromPipelineByPropertyName, Position = 2, Mandatory = $true)]
        [parameter(ParameterSetName = 'Dependency', ValueFromPipelineByPropertyName, Position = 3, Mandatory = $true)]
        [int32]$ScriptID
    )

    begin {
    }
    process {
        # Build the Custom object to convert to json and send to the api.
        $body = [PSCustomObject]@{
            "PasswordID" = $PasswordID
            "ScriptID"   = $ScriptID
        }
        # Note:
        # If you wish to execute a script Post Reset, you do not need to add a dependency,
        # or Host record to link it to - you can execute any custom script you like.
        # The order in which scripts are executed can be changed on the previous screen on the password record dependency screen.
        if ($DependencyType) {
            $body | Add-Member -NotePropertyName "DependencyType" -NotePropertyValue $DependencyType
        }
        if ($DependencyName) {
            $body | Add-Member -NotePropertyName "DependencyName" -NotePropertyValue $DependencyName
        }
        if ($HostName) {
            $body | Add-Member -NotePropertyName "HostName" -NotePropertyValue $HostName
        }
        # Adding API Key to the body if using APIKey as Authentication Type to use the api instead of winAPI
        $penv = Get-PasswordStateEnvironment
        if ($penv.AuthType -eq "APIKey") {
            $body | Add-Member -MemberType NoteProperty -Name "APIKey" -Value $penv.Apikey
        }
        if ($PSCmdlet.ShouldProcess("DependencyType: $DependencyType with DependencyName: $DependencyName for PasswordID: $PasswordID, using script: $ScriptID")) {
            $body = "$($body|ConvertTo-Json)"
            $output = New-PasswordStateResource -uri "/api/dependencies" -body $body
        }
    }

    end {
        return $output
    }
}