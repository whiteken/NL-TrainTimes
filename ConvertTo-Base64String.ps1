function ConvertTo-Base64String {
    param(
        #System Bytes
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][System.Byte]$Byte
    )   

    begin{}

    process{
        [array]$collector += $Byte
        if($collector.Count -gt 172){
            Throw "Error max length of Base64 string exceeded"
        }
    }

    end{
        try{
            [System.Convert]::ToBase64String($collector) 
        }
        catch{
            Throw "Error encoding bytes to Base64: $_"
        }    
    }
}