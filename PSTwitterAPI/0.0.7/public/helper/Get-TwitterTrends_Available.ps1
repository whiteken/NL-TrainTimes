﻿function Get-TwitterTrends_Available {
<#
.SYNOPSIS
    Get locations with trending topics

.DESCRIPTION
    GET trends/available
    
    Returns the locations that Twitter has trending topic information for.
    
    The response is an array of "locations" that encode the location's WOEID and some other human-readable information such as a canonical name and country the location belongs in.
    
    A WOEID is a Yahoo! Where On Earth ID.


.NOTES
    This helper function was generated by the information provided here:
    https://developer.twitter.com/en/docs/trends/locations-with-trending-topics/api-reference/get-trends-available

#>
    [CmdletBinding()]
    Param(
        
    )
    Begin {

        [hashtable]$Parameters = $PSBoundParameters
                   $CmdletBindingParameters | ForEach-Object { $Parameters.Remove($_) }

        [string]$Method      = 'GET'
        [string]$Resource    = '/trends/available'
        [string]$ResourceUrl = 'https://api.twitter.com/1.1/trends/available.json'

    }
    Process {

        # Find & Replace any ResourceUrl parameters.
        $UrlParameters = [regex]::Matches($ResourceUrl, '(?<!\w):\w+')
        ForEach ($UrlParameter in $UrlParameters) {
            $UrlParameterValue = $Parameters["$($UrlParameter.Value.TrimStart(":"))"]
            $ResourceUrl = $ResourceUrl -Replace $UrlParameter.Value, $UrlParameterValue
        }

        If (-Not $OAuthSettings) { $OAuthSettings = Get-TwitterOAuthSettings -Resource $Resource }
        Invoke-TwitterAPI -Method $Method -ResourceUrl $ResourceUrl -Parameters $Parameters -OAuthSettings $OAuthSettings

    }
    End {

    }
}
