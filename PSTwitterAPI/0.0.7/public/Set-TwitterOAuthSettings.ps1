function Set-TwitterOAuthSettings {

    [CmdletBinding()]
    Param(
        $ApiKey,
        $ApiSecret,
        $AccessToken,
        $AccessTokenSecret,
        [switch]$PassThru,
        [switch]$Force
    )
    Process {

        $OAuthSettings = @{
            ApiKey = $ApiKey
            ApiSecret = $ApiSecret
            AccessToken = $AccessToken
            AccessTokenSecret = $AccessTokenSecret
        }

        $RateLimitStatus = Get-TwitterApplication_RateLimitStatus
        If ($RateLimitStatus.rate_limit_context.access_token -ne $AccessToken) { Throw 'RateLimitStatus was returned for the wrong AccessToken.'}
        
        $OAuthSettings['RateLimitStatus'] = ConvertFrom-RateLimitStatus -RateLimitStatus $RateLimitStatus
        
        $OAuthSettings | Export-CliXML -Path "$(${function:Set-TwitterOAuthSettings}.module.modulebase)\private\Oauthfile.cli.xml"

        If ($PassThru) { $OAuthSettings }

    }

}