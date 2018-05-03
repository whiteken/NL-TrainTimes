Import-Module $PSScriptRoot\..\NSTrainTime.psd1 -ArgumentList $true

InModuleScope NSTrainTime {
    Describe Get-NSTrainStation {

        Context "Fresh start" {

            #Should call Get-Date once
            #Should call New-Object once
            #Should call Import-PowerShellDataFile once

        }

        Context "Bad stuff" {

            Mock -CommandName Get-NSAPICredential -MockWith {Throw '[Pester]'} -Verifiable
            
            try{
                $result = Get-NSTrainStation -StationName 'Dummy'
            }
            catch{
                $result = $_
            }

            It "Should error if Get-NSAPICredential throws" {
                $result | Should -BeExactly "[Pester]"
            }

            It "Should call Get-NSAPICredential once" {
                Assert-MockCalled Get-NSAPICredential -Exactly 1  
            }
        }

        Context "API Creds are retrieved" {

            Mock -CommandName Get-NSAPICredential -MockWith {
                [hashtable]@{
                    Username = 'email@domain.com'
                    Password = 'APICredentialPassword'
                }
            }
            
            try{
                $result = Get-NSTrainStation -StationName 'Dummy'
            }
            catch{}

            It "Should call Get-NSAPICredential once" {
                Assert-MockCalled Get-NSAPICredential -Exactly 1  
            }
        }   

        Context "API Creds do not contain username" {
            Mock -CommandName Get-NSAPICredential -MockWith {
                [hashtable]@{
                    Password = 'APICredentialPassword'
                }
            }

            It "Should call Get-NSAPICredential once" {
                Assert-MockCalled Get-NSAPICredential -Exactly 1  
            }

            try{
                $result = Get-NSTrainStation -StationName 'Dummy'
            }
            catch{
                $result = $_
            }

            It "Should throw if username is blank in hashtable" {
                $result | Should -BeExactly "Error No username or password retrieved"
            }
        }
    }
}