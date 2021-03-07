#Requires -Module @{ModuleName='NSTrainTime'; RequiredVersion='2.0.0.0'}
function Get-NSTrainJourney {
<#
.SYNOPSIS
    Find trains between two destinations
.DESCRIPTION
    Got a bit fed up turning up at the station to find trains were delayed or cancelled, so wrote this function to find out in advance before leaving the office

    Function determines train availability from the Dutch NS API (https://www.ns.nl/en/travel-information/ns-api) via Azure Serverless Function
    Use an Internet connected machine
.NOTES
    Author: Kenny White 07/03/2020
.EXAMPLE
    Get-NSTrainJourney -fromStation 'Amsterdam Zuid' -toStation 'Duivendrecht'
    Gets information about next trains from Amsterdam Zuid to Duivendrecht
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

        #Optional URL
        [Parameter(Position = 2)]
        [uri]$URI = 'https://nstraintime2.azurewebsites.net/api/Get-NSTrainJourney'
    )

    $body = [PSCustomObject]@{
        fromStation = $fromStation
        toStation = $toStation
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -uri $uri -Method Post -Body $body

    $result | ForEach-Object {
        [NSJourney]::new(
            $_.fromStation,
            $_.toStation,
            $_.Stops,
            $_.DurationMins,
            $_.DeparturePlatform,
            $_.Status,
            $_.CrowdForecast,
            $_.Punctuality,
            $_.DepartureTime,
            $_.ArrivalTime
        )
    }
}