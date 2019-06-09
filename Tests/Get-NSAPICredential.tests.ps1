param(
    #This is passed in from AzureDevOps during the build
    #otherwise look to the parent folder from where the Tests are located
    [parameter()][string]$BuildFolder='..'
)

$global:BuildFolder = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests','\Module'

Get-Module NSTrainTime | Remove-Module
Import-Module "$BuildFolder\NSTrainTime.psd1" –ArgumentList $true -Force -ErrorAction Stop -Verbose -Scope Local

InModuleScope NSTrainTime {
    Describe Get-NSAPICredential {

        Context "Powershell data file is available" {
            
            Mock -CommandName Import-PowerShellDataFile -MockWith {
                [hashtable]@{
                    Username = 'email@domain.com'
                    APIKey = 'APIKeyPester'
                }
            }

            $result = Get-NSAPICredential
            
            It "Function should return hashtable" {
                $result | Should -BeofType [hashtable] -Because "Hashtable has API user specific credentials needed to connect to REST API"
            } 

            It "Result should contain a username" {
                $result.Username | Should -BeofType [string] -Because "we expect this in the calling function to correctly build the API creds"
            }

            It "Result should contain a password" {
                $result.APIKey | Should -BeofType [string] -Because "we expect this in the calling function to correctly build the API creds"
            }

            It "Username should be value from file" {
                $result.Username | Should -BeExactly 'email@domain.com' -Because "we know this is the dummy value set in the mock objects so we are reading it correctly"
            }

            It "Password should be value from file" {
                $result.APIKey | Should -BeExactly 'APIKeyPester' -Because "we know this is the dummy value set in the mock objects so we are reading it correctly"
            }

            It 'Calls Import-PowerShellDataFile exactly once' {    
                Assert-MockCalled Import-PowerShellDataFile -Exactly 1 -Scope Context
            }
        }

        Context "Powershell data file is not available" {
            
            Mock -CommandName Import-PowerShellDataFile -MockWith {
                Throw '>>Pester<<'
            }

            try {
                $result = Get-NSAPICredential -ErrorAction Stop
            }
            catch{
                $result = $_.Exception
            }

            It 'Should throw if file is not available' {
                $result | Should -BeLike "*>>Pester<<*"
            }

            It 'Calls Import-PowerShellDataFile exactly once' {
                Assert-MockCalled Import-PowerShellDataFile -Exactly 1 -Scope Context
            }
        }
    }
}