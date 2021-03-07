#Requires -Module @{ModuleName='NSTrainTime'; RequiredVersion='2.0.0.0'}
function Get-NSTrainStation {
<#
.SYNOPSIS
    Find a list of matching Dutch train stations.
.DESCRIPTION
    Gets train station names from the Dutch NS API (https://www.ns.nl/en/travel-information/ns-api) via Azure Serverless Function
    Use an Internet connected machine

    Requires NSTrainTime module
.NOTES
    Author: Kenny White 07/03/2020
.Example
    Get-NSTrainStation -StationName 'Amsterd'

    Returns sorted results of a wildcard search

    Amsterdam
    Amsterdam Airport
    Amsterdam Amstel
    Amsterdam Bijlmer ArenA
    Amsterdam Centraal
    Amsterdam Holendrecht
    Amsterdam Lelylaan
    Amsterdam Muiderpoort
    Amsterdam RAI
    Amsterdam Science Park
    Amsterdam Sloterdijk
    Amsterdam Van der Madeweg
    Amsterdam Zuid
    Nieuw Amsterdam
#>

    [cmdletbinding()]
    [alias('gnsts')]

    param(
        #Station or part-station name
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Station,

        #Optional NS Train stations API URI
        [Parameter(Position=1)]
        [uri]$URI = "https://nstraintime2.azurewebsites.net/api/Get-NSTrainStation"
    )

    $body = [PSCustomObject]@{Station = $Station} | ConvertTo-Json  

    $result = Invoke-RestMethod -uri $URI -Method Post -Body $body

    $result | ForEach-Object {
        [NSStation]::new(
            $_.UICCode,
            $_.ShortName,
            $_.MiddleName,
            $_.LongName
        )
    }
}