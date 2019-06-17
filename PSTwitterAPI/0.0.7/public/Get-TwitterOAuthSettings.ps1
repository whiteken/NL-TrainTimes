function Get-TwitterOAuthSettings {

    [CmdletBinding()]
    Param($Resource, $AccessToken)

    If ($Resource) {

        $OAuthSettings = Import-CliXML -Path "$(${function:Set-TwitterOAuthSettings}.module.modulebase)\private\Oauthfile.cli.xml"

        $AccessToken = $OAuthSettings.RateLimitStatus |
                       Where-Object { $_.resource -eq "/$Resource" } |
                       Sort-Object @{expression="remaining";Descending=$true}, @{expression="reset";Ascending=$true} |
                       Select-Object -First 1 -Expand AccessToken

    }

    If ($AccessToken) {

        $OAuthSettings = $OAuthSettings.Where({$_.AccessToken -eq $AccessToken}) | Select-Object -First 1

    } Else {

        $OAuthSettings = $OAuthSettings | Get-Random

    }

    If ($OAuthSettings) {
        Write-Verbose "Using AccessToken '$($OAuthSettings.AccessToken)'"
        $OAuthSettings = @{
            ApiKey = $OAuthSettings.ApiKey
            ApiSecret = $OAuthSettings.ApiSecret
            AccessToken = $OAuthSettings.AccessToken
            AccessTokenSecret = $OAuthSettings.AccessTokenSecret
        }
    } Else {
        $OAuthSettings = $null
        Write-Host "No OAuthSettings was found. Use 'Set-TwitterOAuthSettings' to set PSTwitterAPI ApiKey & Token."
    }

    Return $OAuthSettings

}