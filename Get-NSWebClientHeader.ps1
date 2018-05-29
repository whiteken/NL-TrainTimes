function Get-NSWebClientHeader {
    param(
        #Username
        [Parameter(Mandatory=$true)][string]$Username,
        
        #APIKey
        [Parameter(Mandatory=$true)][string]$APIKey
    )   
    
    try{
        'Basic ' + $([convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Username + ':' + $APIKey))) 
    }
    catch{
        Throw "Error building WebClientHeader: $_"
    }
}