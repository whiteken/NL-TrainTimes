
function Get-NSTrainStation{

    [cmdletbinding()]
    [alias('gnsts')]
        
    Param(
        #Station or part-station name
        [Parameter(Mandatory=$true,Position=0)]
        [string]$StationName,

        #Optional NS Train stations API URI
        [Parameter(Position=1)]
        [string]$URL = "http://webservices.ns.nl/ns-api-stations"
    )

    #Checked in APICredential.psd1 has dummy credentials
    #Request genuine API credenital here: https://www.ns.nl/ews-aanvraagformulier 
    try{
        $apiUser = Get-NSAPICredential -ErrorAction Stop
    }
    catch{
        Throw "Unable to retrieve API credentials. Check that dummy values from APICredential.psd1 are updated: $_"
    }
    
    $credentials = ConvertTo-ByteArray -username $apiUser.Username -APIKey $apiUser.APIKey | ConvertTo-Base64String
    $formatCred = 'Basic ' + $credentials

    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.add('Authorization', $formatCred)
    
    $formatcred = 'Basic ' + $credentials

    $webClient.Headers.add('Authorization',$formatcred)
    
    try{
        [xml]$xml = $webClient.DownloadString($URL)
    }
    catch{
        Throw "Cannot download train info from NS website: $_"        
    }

    $xml.SelectNodes("//station").Where({$_.name -like "*$StationName*"}).ForEach({$_.name})
}





