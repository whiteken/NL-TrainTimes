#Requires -Module @{ModuleName='NSTrainTime'; RequiredVersion='1.1.0.0'}
function Get-NSXML {

    [cmdletbinding()]
    [outputtype([xml])]
    param(
        #Formatted credential string for Web client header
        [Parameter(Mandatory=$true, Position=0)][string]$WebClientHeaderAuth,

        #NS API resource
        [Parameter(Mandatory=$true, Position=1)]
        [uri]$URI
    )

    try{
        $webClient = New-Object System.Net.WebClient -ErrorAction Stop
        $webClient.Headers.add('Authorization', $WebClientHeaderAuth)
    }
    catch{
        Throw "Web client error: $_"
    }

    try{
        [xml]$webClient.DownloadString($URI)
        $webClient.Dispose()
    }
    catch{
        Throw "Cannot download info from NS website: $_"
    }
}