function ConvertTo-ByteArray {
    param(
        #Username
        [Parameter(Mandatory=$true)][string]$Username,
        
        #APIKey
        [Parameter(Mandatory=$true)][string]$APIKey
    )   
    
    try{
        [System.Text.Encoding]::UTF8.GetBytes($($Username + ':' + $APIKey))
    }
    catch{
        Throw "Error encoding to bytes: $_"
    }
}