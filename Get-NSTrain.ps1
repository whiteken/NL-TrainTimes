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
        $toStation,

        #Optional URL
        [Parameter(Position = 2)]
        [URI]$URI = "http://webservices.ns.nl/ns-api-treinplanner"
    )
    
    #Get todays date 
    $date = Get-Date -format s     

    #Add the filters
    [uri]$filteredURI = $URI.OriginalString + "?toStation=$toStation&fromStation=$fromStation&Departure=true&datetime=$date"

    try{
        $apiUser = Get-NSAPICredential -ErrorAction Stop
    }
    catch{
        Throw "Unable to retrieve API credentials. Check that dummy values from APICredential.psd1 are updated: $_"
    }
    
    $credentials = ConvertTo-ByteArray -Username $apiUser.Username -APIKey $apiUser.APIKey | ConvertTo-Base64String
    $formatCred = 'Basic ' + $credentials

    [xml]$xml = Get-NSXML -WebClientHeaderAuth $formatCred -URI $filteredURI
    
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
