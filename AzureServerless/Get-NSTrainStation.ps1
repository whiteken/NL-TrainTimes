

[uri]$URI = "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v2/stations"

$headers = @{
    "Ocp-Apim-Subscription-Key" = "05f42a95c2cf468797f4fee7fe700cc5"
}

$Station = "Hilver"

$raw = Invoke-RestMethod -Uri $URI -Headers $headers -Method Get

$raw.PayLoad | ForEach-Object {
    [PSCustomObject]@{
        UICCode = $_.UICCode
        ShortName = $_.Namen.kort 
        MiddleName = $_.Namen.middel 
        LongName = $_.Namen.lang
    }
} | Where-Object {$_.LongName -like "*$Station*"} | ConvertTo-Json




$body = [PSCustomObject]@{Station='RAI'} | ConvertTo-Json
Invoke-RestMethod -uri https://nstraintime2.azurewebsites.net/api/Get-NSTrainStation -Method Post -Body $body