class nsTrainStationFromCompleter : Management.Automation.IArgumentCompleter {
    [Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument (
        [String]$commandName,
        [String]$parameterName,
        [String]$wordToComplete,
        [System.Management.Automation.Language.CommandAst]$commandAst,
        [System.Collections.IDictionary]$fakeBoundParameters
    ) {

        [System.Management.Automation.CompletionResult[]] $result = foreach ($fromStation in $(Get-NSTrainStation -StationName $wordToComplete | Sort-Object -Unique)) {

            $fromStation = "'$fromStation'"

            [System.Management.Automation.CompletionResult]::new(
                $fromStation,
                $fromStation,
                [System.Management.Automation.CompletionResultType]::ParameterValue,
                "ns train station: '$fromStation'"
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

            $toStation = "'$toStation'"

            [System.Management.Automation.CompletionResult]::new(
                $toStation,
                $toStation,
                [System.Management.Automation.CompletionResultType]::ParameterValue,
                "ns train station: '$toStation'"
            )
        }
        return $result
    }
}

class NSJourney
{
    [string]$fromStation
    [string]$toStation
    [int]$Changes
    [string]$JourneyTime
    [string]$Delay
    [datetime]$Departure
    [datetime]$Arrival
    [string]$Status

    NSJourney([string]$fromStation,[string]$toStation,[int]$Changes,[string]$JourneyTime,[string]$Delay,[datetime]$Departure,[datetime]$Arrival,[string]$Status){
        $this.fromStation = $fromStation
        $this.toStation = $toStation
        $this.Changes = $Changes
        $this.JourneyTime = $JourneyTime
        $this.Delay = $Delay
        $this.Departure = $Departure
        $this.Arrival = $Arrival
        $this.Status = $Status
    }
}