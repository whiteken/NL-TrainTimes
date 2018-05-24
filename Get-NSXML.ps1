   
function Get-NSXML {

    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.add('Authorization', $formatCred)
    
    try{
        [xml]$xml = $webClient.DownloadString($URI)
    }
    catch{
        Throw "Cannot download train info from NS website: $_"        
    }
}