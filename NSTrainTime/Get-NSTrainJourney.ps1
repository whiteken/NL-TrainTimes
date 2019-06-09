#Requires -Module @{ModuleName='NSTrainTime'; RequiredVersion='1.1.0.0'}
function Get-NSTrainJourney {
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
Get-NSTrainJourney -fromStation 'Amsterdam Zuid' -toStation 'Duivendrecht'
Gets information about next 10 trains from Amsterdam Zuid to Duivendrecht

#>
    [cmdletbinding()]
    [alias('gnstj')]
    Param(
        #Journey start station
        [Parameter(Mandatory = $true, Position = 0)]
        [ArgumentCompleter([nsTrainStationFromCompleter])]
        $fromStation,

        #Journey end station
        [Parameter(Mandatory = $true, Position = 1)]
        [ArgumentCompleter([nsTrainStationToCompleter])]
        $toStation,

        #Specify a value from 1-5 to retrieve info on next x train journeys
        [ValidateRange(1,5)]
        [Parameter()][int]$Next,

        #Optional URL
        [Parameter(Position = 2)]
        [uri]$URI = "http://webservices.ns.nl/ns-api-treinplanner"
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

    $formatCred = Get-NSWebClientHeader -Username $apiUser.Username -APIKey $apiUser.APIKey

    [xml]$xml = Get-NSXML -WebClientHeaderAuth $formatCred -URI $filteredURI

    $filtered = @()

    $xml.SelectNodes('//ReisMogelijkheid') | ForEach-Object {

        [datetime]$StartDate = $_.GeplandeVertrekTijd
        [datetime]$EndDate = $_.ActueleVertrekTijd

        $delay = $(New-TimeSpan -Start $StartDate -End $EndDate) -f '+HH:mm'

        $result = [NSJourney]::new(
            $fromStation,
            $toStation,
            $_.AantalOverstappen,
            $(Get-Date ($_.GeplandeReisTijd) -f HH:mm),
            $delay,
            $(Get-Date ($_.ActueleVertrekTijd) -f HH:mm),
            $(Get-Date ($_.ActueleAankomstTijd) -f HH:mm),
            $_.Status
        )

        if($Next){
            if($result.Departure -ge [datetime]::Now){
                $filtered += $result
            }
        }
        else{
            $result
        }
    }

    if($Next){
        $filtered | Sort-Object Departure | Select-Object -First $Next
    }
}
