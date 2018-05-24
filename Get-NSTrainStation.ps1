
function Get-NSTrainStation{

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
        $apiUser = Get-NSAPICredential -ErrorAction Stop
    }
    catch{
        Throw "Unable to retrieve API credentials. Check that dummy values from APICredential.psd1 are updated: $_"
    }
    
    $credentials = ConvertTo-ByteArray -Username $apiUser.Username -APIKey $apiUser.APIKey | ConvertTo-Base64String
    $formatCred = 'Basic ' + $credentials

    [xml]$xml = Get-NSXML -WebClientHeaderAuth $formatCred -URI "http://webservices.ns.nl/ns-api-stations"

    $xml.SelectNodes("//station").Where({$_.name -like "*$StationName*"}).ForEach({$_.name})
}





