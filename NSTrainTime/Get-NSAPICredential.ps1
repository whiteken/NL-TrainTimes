#Requires -Module @{ModuleName='NSTrainTime'; RequiredVersion='1.1.0.0'}
function Get-NSAPICredential{

    [cmdletbinding()]

    Param(
        #Path to powershell data file containing API credential info
        [Parameter()][string]$PowershellDataFile ="$PSScriptRoot\APICredential.psd1"
    )

    try{
        $result = Import-PowershellDataFile $PowershellDataFile -ErrorAction Stop
    }
    catch{
        Throw "Error loading API credential info from PowershellDataFile: $_"
    }

    if($result.Username -eq '<email@address.com>'){
        Write-Warning 'Before using this module you must update the APIcredentials.psd1 file'
        Break
    }
    else{
        $result
    }
}