class nsTrainStationFromCompleter : Management.Automation.IArgumentCompleter {
    [Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument (
        [String]$commandName,
        [String]$parameterName,
        [String]$wordToComplete,
        [System.Management.Automation.Language.CommandAst]$commandAst,
        [System.Collections.IDictionary]$fakeBoundParameters
    ) {
        
        [System.Management.Automation.CompletionResult[]] $result = foreach ($fromStation in $(Get-NSTrainStation -StationName $wordToComplete | Sort-Object -Unique)) {
            $tokens = $null 
            $null = [System.Management.Automation.Language.Parser]::ParseInput("echo $fromStation", [ref]$tokens, [ref]$null) 
            if (
                $tokens[1] -is [System.Management.Automation.Language.StringExpandableToken] -and 
                $tokens[1].Kind -eq [System.Management.Automation.Language.TokenKind]::Generic
            ) { 
                $fromStation = "'$fromStation'" 
            } 
            
            [System.Management.Automation.CompletionResult]::new(
                $fromStation,
                $fromStation,
                [System.Management.Automation.CompletionResultType]::ParameterValue,
                "ns train station: $fromStation"
            )
        }
        return $result
    }
}



class nsTrainStationToCompleter : Management.Automation.IArgumentCompleter {
    [Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument (
        [String]$commandName,
        [String]$parameterName,
        [String]$wordToComplete,
        [System.Management.Automation.Language.CommandAst]$commandAst,
        [System.Collections.IDictionary]$fakeBoundParameters
    ) {
        
        [System.Management.Automation.CompletionResult[]] $result = foreach ($toStation in $(Get-NSTrainStation -StationName $wordToComplete | Sort-Object -Unique)) {
            $tokens = $null 
            $null = [System.Management.Automation.Language.Parser]::ParseInput("echo $toStation", [ref]$tokens, [ref]$null) 
            if (
                $tokens[1] -is [System.Management.Automation.Language.StringExpandableToken] -and 
                $tokens[1].Kind -eq [System.Management.Automation.Language.TokenKind]::Generic
            ) { 
                $toStation = "'$toStation'" 
            } 
            
            [System.Management.Automation.CompletionResult]::new(
                $toStation,
                $toStation,
                [System.Management.Automation.CompletionResultType]::ParameterValue,
                "ns train station: $toStation"
            )
        }
        return $result
    }
}