using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$fromStation = $Request.Query.fromStation
if (-not $fromStation) {
    $fromStation = ($Request.Body | ConvertFrom-Json).fromStation
    Write-Host "From station is $fromStation"
}

$toStation = $Request.Query.toStation
if (-not $toStation) {
    $toStation = ($Request.Body | ConvertFrom-Json).toStation
    Write-Host "To station is $toStation"
}

$uri = 'https://gateway.apiportal.ns.nl/reisinformatie-api/api/v3/trips?fromStation={0}&toStation={1}&originWalk=false&originBike=false&originCar=false&destinationWalk=false&destinationBike=false&destinationCar=false&shorterChange=false&travelAssistance=false&searchForAccessibleTrip=false&localTrainsOnly=false&excludeHighSpeedTrains=false&excludeTrainsWithReservationRequired=false&yearCard=false&discount=NO_DISCOUNT&travelClass=2&polylines=false&passing=false&travelRequestType=DEFAULT' -f $fromStation, $toStation

#Retrieve code from https://apiportal.ns.nl/signin?ReturnUrl=%2Fdeveloper
#replace during AzureDevOps build from AZ keyvault
$headers = @{
    "Ocp-Apim-Subscription-Key" = "%%ns-subscription-key%%"
}

$raw = Invoke-RestMethod -Uri $URI -Headers $headers -Method Get

$body = $raw.trips | ForEach-Object {
    [PSCustomObject]@{
        FromStation = $fromStation
        ToStation = $toStation
        Stops = $($_.legs.stops.name).count
        DurationMins = $_.plannedDurationInMinutes
        DeparturePlatform = $_.legs.stops.plannedDepartureTrack[0]
        Status = $_.Status
        CrowdForecast = $_.crowdForecast
        Punctuality = $_.punctuality  
        DepartureTime = $_.legs.stops.plannedDepartureDateTime[0]
        ArrivalTime = $_.legs.stops.plannedArrivalDateTime[-1]
    }
}


Write-Host "Returned number of trips: $($raw.trips | Measure-Object | Select-Object -expandProperty Count)"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body

})
