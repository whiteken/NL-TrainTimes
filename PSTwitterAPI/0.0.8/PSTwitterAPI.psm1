param (
    #Specify: -ArgumentList $true on Import-Module to alter behaviour an AzureDevOps pipeline.
    [parameter(Position=0,Mandatory=$false)][bool]$AZDO
)

if(-not($AZDO)){
    $Script:OAuthCollection = [System.Collections.ArrayList]@()
}
else{
    if(-not(Test-Path -path "$PSScriptRoot\private\flag.cli.xml" -ErrorAction SilentlyContinue)){
        Write-Warning "You have specified 'true' as a module load -Argumentlist parameter.`nThis switch is designed for use in an AzureDevOps pipeline.`n The parameter causes API credentials to be stored in a file.`nTo ensure that they are removed use Remove-Module."
        'Azure DevOps pipeline fix' | Export-CliXML -Path "$PSScriptRoot\private\flag.cli.xml"
        $module = $MyInvocation.MyCommand.ScriptBlock.Module
        $module.OnRemove = {
            Get-Item -Path "$PSScriptRoot\private\flag.cli.xml" | Remove-Item -Verbose
            Get-Item -Path "$PSScriptRoot\private\OAuthSettings.cli.xml" | Remove-Item -Verbose
        }
    }
}

$Script:EndPointBaseUrl = 'https://api.twitter.com/1.1'
$Script:EndPointFileFormat = 'json'

$Script:CmdletBindingParameters = @('Verbose','Debug','ErrorAction','WarningAction','InformationAction','ErrorVariable','WarningVariable','InformationVariable','OutVariable','OutBuffer','PipelineVariable')

#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files.
Foreach ($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename