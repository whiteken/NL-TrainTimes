param($global:BuildFolder)

$global:BuildFolder = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests','\NSTrainTime'

Get-Module NSTrainTime | Remove-Module
Import-Module "$global:buildFolder\NSTrainTime.psd1" –ArgumentList $true -Force -ErrorAction Stop -Verbose -Scope Local

InModuleScope NSTrainTime {
    
    Describe 'NSTrainTime individual pester tests' {
    
        Context 'Checking files to test exist and Invoke-ScriptAnalyzer is available'{
                
            It 'Checking files exist to test'{
                $moduleFiles = Get-ChildItem $global:BuildFolder\* -Include *.psd1, *.psm1, *.ps1 -Exclude *.tests.ps1 -Recurse
                $moduleFiles.count | Should Not Be 0
            }          
            
            It 'Checking Invoke-ScriptAnalyzer exists' {
                { Get-Command Invoke-ScriptAnalyzer -ErrorAction Stop } | Should Not Throw
            }

            $scriptAnalyzerRules = Get-ScriptAnalyzerRule
            $moduleFiles = Get-ChildItem $global:BuildFolder\* -Include *.psd1, *.psm1, *.ps1 -Exclude *.tests.ps1, *.txt -Recurse

            foreach ($file in $moduleFiles){

                switch -wildCard ($file){ 
                    '*.psm1' {$testType = 'Module'} 
                    '*.ps1'  {$testType = 'Script'} 
                    '*.psd1' {$testType = 'Manifest'} 
                }

                Context "Checking $($file.name) - meets $testType PSScriptAnalyzer Rule"{
                    foreach ($scriptAnalyzerRule in $scriptAnalyzerRules){
                        It "Script Analyzer Rule $scriptAnalyzerRule" {
                            (Invoke-ScriptAnalyzer -Path $file -IncludeRule $scriptAnalyzerRule).count | Should Be 0
                        }
                    }
                }
            }
        }
    }
}