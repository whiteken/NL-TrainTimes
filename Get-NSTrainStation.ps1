#Requires -Module @{ModuleName='NSTrainTime'; RequiredVersion='1.1.0.0'}
function Get-NSTrainStation{

<#
.SYNOPSIS
Find a list of matching Dutch train stations

.DESCRIPTION
Gets train station names from the Dutch NS API (https://www.ns.nl/en/travel-information/ns-api)
Needs connection to External API http://webservices.ns.nl/ns-api-treinplanner
Use an Internet connected machine

Requires NSTrainTime module

.NOTES
Author: Kenny White 08/06/2019

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

    Param(
        #Station or part-station name
        [Parameter(Mandatory=$true,Position=0)]
        [string]$StationName,

        #Optional NS Train stations API URI
        [Parameter(Position=1)]
        [uri]$URI = "http://webservices.ns.nl/ns-api-stations"
    )

    try{
        $apiUser = Get-NSAPICredential -ErrorAction Stop -verbose
    }
    catch{
        Throw "Unable to retrieve API credentials. Check that dummy values from APICredential.psd1 are updated: $_"
    }

    $formatCred = Get-NSWebClientHeader -Username $apiUser.Username -APIKey $apiUser.APIKey

    [xml]$xml = Get-NSXML -WebClientHeaderAuth $formatCred -URI "http://webservices.ns.nl/ns-api-stations"

    $xml.SelectNodes("//station").Where({$_.name -like "*$StationName*"}).ForEach({
        $_.name
    })
}