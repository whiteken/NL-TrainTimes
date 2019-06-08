#Requires -Module @{ModuleName='NSTrainTime'; RequiredVersion='1.1.0.0'}
function Get-NSAPICredential{

    [cmdletbinding()]

    Param(
        #Path to powershell data file containing API credential info
        [Parameter()][string]$PowershellDataFile ="APICredential.psd1"
    )

    try{
        Import-PowershellDataFile $PowershellDataFile -ErrorAction Stop
    }
    catch{
        Throw "Error loading API credential info from PowershellDataFile: $_"
    }
}