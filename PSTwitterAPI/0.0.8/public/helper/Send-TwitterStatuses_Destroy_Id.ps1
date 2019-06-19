﻿function Send-TwitterStatuses_Destroy_Id {
<#
.SYNOPSIS
    Post, retrieve and engage with Tweets

.DESCRIPTION
    POST statuses/destroy/:id
    
    Destroys the status specified by the required ID parameter. The authenticating user must be the author of the specified status. Returns the destroyed status if successful.

.PARAMETER id
    The numerical ID of the desired status.

.PARAMETER trim_user
    When set to either true , t or 1 , each tweet returned in a timeline will include a user object including only the status authors numerical ID. Omit this parameter to receive the complete user object.

.NOTES
    This helper function was generated by the information provided here:
    https://developer.twitter.com/en/docs/tweets/post-and-engage/api-reference/post-statuses-destroy-id

#>
    [CmdletBinding()]
    Param(
        [string]$id,
        [string]$trim_user
    )
    Begin {

        [hashtable]$Parameters = $PSBoundParameters
                   $CmdletBindingParameters | ForEach-Object { $Parameters.Remove($_) }

        [string]$Method      = 'POST'
        [string]$Resource    = '/statuses/destroy/:id'
        [string]$ResourceUrl = 'https://api.twitter.com/1.1/statuses/destroy/:id.json'

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