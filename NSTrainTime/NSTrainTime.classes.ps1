class nsTrainStationFromCompleter : Management.Automation.IArgumentCompleter {
    [Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument (
        [String]$commandName,
        [String]$parameterName,
        [String]$wordToComplete,
        [System.Management.Automation.Language.CommandAst]$commandAst,
        [System.Collections.IDictionary]$fakeBoundParameters
    ) {

        [System.Management.Automation.CompletionResult[]] $result = foreach ($fromStation in $(Get-NSTrainStation -Station $wordToComplete | Select-Object -ExpandProperty LongName | Sort-Object -Unique)) {

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

        [System.Management.Automation.CompletionResult[]] $result = foreach ($toStation in $(Get-NSTrainStation -Station $wordToComplete | Select-Object -ExpandProperty LongName | Sort-Object -Unique)) {

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
    [int]$Stops
    [int]$DurationMins
    [string]$DeparturePlatform
    [string]$Status
    [string]$CrowdForecast
    [double]$Punctuality
    [datetime]$DepartureTime
    [datetime]$ArrivalTime

    NSJourney(
        [string]$fromStation,
        [string]$toStation,
        [int]$Stops,
        [int]$DurationMins,
        [string]$DeparturePlatform,
        [string]$Status,
        [string]$CrowdForecast,
        [double]$Punctuality,
        [datetime]$DepartureTime,
        [datetime]$ArrivalTime
    ){
        $this.fromStation = $fromStation
        $this.toStation = $toStation
        $this.Stops = $Stops
        $this.DurationMins = $DurationMins
        $this.DeparturePlatform = $DeparturePlatform
        $this.Status = $Status
        $this.CrowdForecast = $CrowdForecast
        $this.Punctuality = $Punctuality
        $this.DepartureTime = $DepartureTime
        $this.ArrivalTime = $ArrivalTime
    }
}

class NSStation
{
    [string]$UICCode
    [string]$ShortName
    [string]$MiddleName
    [string]$LongName

    NSStation(
        [string]$UICCode,
        [string]$ShortName,
        [string]$MiddleName,
        [string]$LongName
    ){
        $this.UICCode = $UICCode
        $this.ShortName = $ShortName
        $this.MiddleName = $MiddleName
        $this.LongName = $LongName
    }
}