param(
    #This is passed in from AzureDevOps during the build
    #otherwise look to the parent folder from where the Tests are located
    [parameter()][string]$BuildFolder='..'
)

Get-Module NSTrainTime | Remove-Module
Import-Module $BuildFolder\NSTrainTime.psd1 –ArgumentList $true -Force -ErrorAction Stop -Verbose:$false
$prefix = 'NS'

InModuleScope NSTrainTime {
    
    Describe 'NSTrainTime individual pester tests' {
        
        BeforeAll{
            $manifest = Import-PowerShellDataFile $BuildFolder\NSTrainTime.psd1
            $manifestFunctions = ($manifest.FunctionsToExport).Split('')
        }      
        
        foreach($functionName in $manifestFunctions){
            
            $functionFile = "$BuildFolder\$functionName.ps1"

            Context "Standardised module tests for $functionName function"{
                
                It "Function file should contain valid PowerShell code" {
                    $content = Get-Content $functionFile -ErrorAction Stop
                    $errorTotal = $null
                    $null = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$errorTotal)
                    $errorTotal.Count | Should Be 0
                }

                It "Function name should have correct prefix for module"{
                    $functionName -match "-$prefix.+?" | Out-Null
                    try{
                        $result = $matches[1]
                    }
                    catch{
                        $result = $false
                    }
                    $result -eq $prefix | Should be $true
                }
                                
                It "Function from module manifest should a have corresponding .ps1 file"{
                    Get-Item $functionFile | Should not be $null
                }
                
                It 'Function from module should have valid #Requires statement'{
                    $result = Get-Content $functionFile | Select-Object -First 1
                    $pattern = "^#Requires -Module @{ModuleName='NSTrainTime'; RequiredVersion='\d+.\d+.\d+.\d+'}$"
                    $result -match $pattern | Should -be $true
                }

                It 'Requires statement should reference current or previous (i.e not newer) module'{
                    $result = Get-Content $functionFile | Select-Object -First 1
                    $pattern = "RequiredVersion='(\d+.\d+.\d+.\d+)'"
                    $result -match $pattern
                    #Next use automatic matches variable
                    [version]$requiresVersion = $matches[1]
                    [version]$moduleVersion = Get-Module NSTrainTime | Select-Object -ExpandProperty Version
                    $requiresVersion -le $moduleVersion | Should -be $true
                }

                It 'Function from module should use [Cmdletbinding()]'{
                    $result = Get-Content $functionFile
                    $pattern = "\[Cmdletbinding\(\)\]"
                    $result -match $pattern | Should -Be $true
                }

                It 'Function from module should have valid help description'{
                    $result = Get-Help $functionName | Select-Object -ExpandProperty Description
                    $result | Should -not -BeNullOrEmpty
                }

                It 'Function from module should have valid help example(s)'{
                    $result = $(Get-Command $functionName | Get-Help -detailed ) -match 'EXAMPLE'
                    $result | Should be $true
                }
                
                #If the function file specifies an alias then that alias should also be exported in the module manifest
                $content = Get-Content $functionFile
                $pattern = "\[Alias\('(.+?)'\)\]"
                $result = [regex]::Match($content,$pattern)
            
                $functionFileAlias = $result.groups[1].value

                if($functionFileAlias){

                    It "Alias from function file '$functionFileAlias' should also be exported in module manifest" {

                       $result = [string[]](Import-PowerShellDataFile $global:testFile).AliasesToExport -contains $functionFileAlias
                       $result | Should -Be $true
                    }
                }
            }
        }

        Context 'Checking files to test exist and Invoke-ScriptAnalyzer is available'{
            
            It 'Checking files exist to test'{
                $moduleFiles = Get-ChildItem $BuildFolder\* -Include *.psd1, *.psm1, *.ps1 -Exclude *.tests.ps1 -Recurse
                $moduleFiles.count | Should Not Be 0
            }          
            
            It 'Checking Invoke-ScriptAnalyzer exists' {
                { Get-Command Invoke-ScriptAnalyzer -ErrorAction Stop } | Should Not Throw
            }
        }

        $scriptAnalyzerRules = Get-ScriptAnalyzerRule
        $moduleFiles = Get-ChildItem $BuildFolder\* -Include *.psd1, *.psm1, *.ps1 -Exclude *.tests.ps1, *.txt -Recurse

        foreach ($file in $moduleFiles){
            
            switch -wildCard ($file){ 
                '*.psm1' {$testType = 'Module'} 
                '*.ps1'  {$testType = 'Script'} 
                '*.psd1' {$testType = 'Manifest'} 
            }
    
            Context "Checking $($file.name) - meets $testType PSScriptAnalyzer Rule"{
                foreach ($scriptAnalyzerRule in $scriptAnalyzerRules){
                    It "Script Analyzer Rule $scriptAnalyzerRule"{
                        (Invoke-ScriptAnalyzer -Path $file -IncludeRule $scriptAnalyzerRule).count | Should Be 0
                    }
                }
            }
        }
    }
}
