function Get-NSTrain {
    <#
.SYNOPSIS
Find trains between two destinations

.DESCRIPTION
Got a bit fed up turning up at the station to find trains were delayed or cancelled, so wrote this function to find out in advance before leaving the office

Function determines train availability from the Dutch NS API (https://www.ns.nl/en/travel-information/ns-api)
Needs connection to External API http://webservices.ns.nl/ns-api-treinplanner
Use an Internet connected machine

Request API access here: https://www.ns.nl/ews-aanvraagformulier/?0
            
.NOTES
Author: Kenny White 14/01/2016

.Example
Get-NSTrain -fromStation 'Amsterdam Zuid' -toStation 'Duivendrecht'
Gets information about next 10 trains from Amsterdam Zuid to Duivendrecht

#>
    [cmdletbinding()]
    [alias('gnst')]
    Param(
        #Journey start station
        [Parameter(Mandatory = $true, Position = 0)]
        [ArgumentCompleter([nsTrainStationFromCompleter])]  
        $fromStation,

        #Journey end station
        [Parameter(Mandatory = $true, Position = 1)]
        [ArgumentCompleter([nsTrainStationToCompleter])]
        $toStation
    )
        
    $date = Get-Date -format s     

    $url = "http://webservices.ns.nl/ns-api-treinplanner?toStation=$toStation&fromStation=$fromStation&Departure=true&datetime=$date"
    $webClient = New-Object System.Net.WebClient

    #Checked in APICredential.psd1 has dummy credentials
    #Request genuine API credenital here: https://www.ns.nl/ews-aanvraagformulier 
    try{
        $apiUser = Import-PowerShellDataFile ./APICredential.psd1 -ErrorAction Stop
    }
    catch{
        Throw "Unable to retrieve API credentials. Check that dummy values from APICredential.psd1 are updated: $_"
    }

    $username = $apiUser.Username
    $password = $apiUser.Password

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($($username + ':' + $password))
    $credentials = [System.Convert]::ToBase64String($bytes)  
    
    $formatcred = 'Basic ' + $credentials

    $webClient.Headers.add('Authorization', $formatcred)
    
    try {
        [xml]$xml = $webClient.DownloadString($url)
    }
    catch {
        Throw "Cannot download train info from NS website: $_"       
    }
    
    $xml.SelectNodes('//ReisMogelijkheid') | ForEach-Object {
    
        [datetime]$StartDate = $_.GeplandeVertrekTijd 
        [datetime]$EndDate = $_.ActueleVertrekTijd
        
        $delay = New-TimeSpan -Start $StartDate -End $EndDate
        
        if ($delay -eq 0) {
            $delay = $null
        }
        else {
            $delay = $delay -f '+HH:mm'
        }

        [pscustomobject][ordered]@{    
            'Start'        = $fromStation
            'End'          = $toStation
            'Changes'      = $_.AantalOverstappen
            'Journey Time' = Get-Date ($_.GeplandeReisTijd) -f HH:mm
            'Delay'        = $delay
            'Departure'    = Get-Date ($_.ActueleVertrekTijd) -f HH:mm
            'Arrival'      = Get-Date ($_.ActueleAankomstTijd) -f HH:mm
            'Status'       = $_.Status
        }       
    }
}
