function ConvertTo-ByteArray {
    param(
        #Username
        [Parameter(Mandatory=$true)][string]$Username,
        
        #Password
        [Parameter(Mandatory=$true)][string]$Password
    )   
    
    try{
        [System.Text.Encoding]::UTF8.GetBytes($($username + ':' + $password))
    }
    catch{
        Throw "Error encoding to bytes: $_"
    }
}