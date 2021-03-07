using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$station = $Request.Query.Station
if (-not $station) {
    $station = ($Request.Body | ConvertFrom-Json).Station
    Write-Host "Station is $station"
}

[uri]$uri = "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v2/stations"

#Retrieve code from https://apiportal.ns.nl/signin?ReturnUrl=%2Fdeveloper
#replace during AzureDevOps build from AZ keyvault
$headers = @{
    "Ocp-Apim-Subscription-Key" = "%%ns-subscription-key%%"
}

$raw = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

$result = $raw.PayLoad | ForEach-Object {
    [PSCustomObject]@{
        UICCode = $_.UICCode
        ShortName = $_.Namen.kort 
        MiddleName = $_.Namen.middel 
        LongName = $_.Namen.lang
    }
} | Sort-Object LongName

$result = $result | Where-Object {$_.LongName -like "*$station*"}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $result
})
