
#Assuming we have a PS repo registered somewhere...

if(-not(Get-PackageProvider Nuget)){
    Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
}

If(-not(Get-Module Pester)){
    Install-Module -Name Pester -Force -Verbose -Scope CurrentUser
}

If(-not(Get-Module Pester)){
    Install-Module -Name PSScriptAnalyzer -Force -Verbose -Scope CurrentUser
}