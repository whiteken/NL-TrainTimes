
$fromStation = 'Hilversum'
$toStation = 'Amersfoort'
$uri = 'https://gateway.apiportal.ns.nl/reisinformatie-api/api/v3/trips?fromStation={0}&toStation={1}&originWalk=false&originBike=false&originCar=false&destinationWalk=false&destinationBike=false&destinationCar=false&shorterChange=false&travelAssistance=false&searchForAccessibleTrip=false&localTrainsOnly=false&excludeHighSpeedTrains=false&excludeTrainsWithReservationRequired=false&yearCard=false&discount=NO_DISCOUNT&travelClass=2&polylines=false&passing=false&travelRequestType=DEFAULT' -f $fromStation, $toStation

$headers = @{
    "Ocp-Apim-Subscription-Key" = ""
}

$raw = Invoke-RestMethod -Uri $URI -Headers $headers -Method Get

$raw.trips | ForEach-Object {
    [PSCustomObject]@{
        PlannedDuration = $_.plannedDurationInMinutes
        ActualDuration = $_.actualDurationInMinutes
        DeparturePlatform = $_.legs.stops.plannedDepartureTrack[0]
        Status = $_.Status
        CrowdForecast = $_.crowdForecast
        Type = $_.type
        Punctuality = $_.punctuality  
        Stops = $($_.legs.stops.name).count
        DepartureTime = $_.legs.stops.plannedDepartureDateTime[0]
        ArrivalTime = $_.legs.stops.plannedArrivalDateTime[-1]
    }
}



$body = [PSCustomObject]@{
    fromStation = 'Hilversum'
    toStation = 'Amersfoort'
} | ConvertTo-Json

$uri = 'https://nstraintime2.azurewebsites.net/api/Get-NSTrainJourney'
Invoke-RestMethod -uri $uri -Method Post -Body $body -Verbose | ft
