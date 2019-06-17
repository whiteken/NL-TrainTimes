﻿function Get-TwitterCollections_Show {
<#
.SYNOPSIS
    Curate a collection of Tweets

.DESCRIPTION
    GET collections/show
    
    Retrieve information associated with a specific Collection.

.PARAMETER id
    The identifier of the Collection for which to return results.

.NOTES
    This helper function was generated by the information provided here:
    https://developer.twitter.com/en/docs/tweets/curate-a-collection/api-reference/get-collections-show

#>
    [CmdletBinding()]
    Param(
        [string]$id
    )
    Begin {

        [hashtable]$Parameters = $PSBoundParameters
                   $CmdletBindingParameters | ForEach-Object { $Parameters.Remove($_) }

        [string]$Method      = 'GET'
        [string]$Resource    = '/collections/show'
        [string]$ResourceUrl = 'https://api.twitter.com/1.1/collections/show.json'

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
