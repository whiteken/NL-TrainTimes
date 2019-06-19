param($global:BuildFolder)

$global:BuildFolder = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests','\NSTrainTime'

Get-Module NSTrainTime | Remove-Module
Import-Module "$global:buildFolder\NSTrainTime.psd1" –ArgumentList $true -Force -ErrorAction Stop -Verbose -Scope Local
$prefix = 'NS'

InModuleScope NSTrainTime {
        
    Describe 'NSTrainTime individual pester tests' {
        
        BeforeAll{
            $manifest = Import-PowerShellDataFile "$global:BuildFolder\NSTrainTime.psd1"
            $manifestFunctions = ($manifest.FunctionsToExport).Split('')
        }      
        
        foreach($functionName in $manifestFunctions){
            
            $functionFile = "$global:BuildFolder\$functionName.ps1"

            Context "Standardised module tests for $functionName function"{
                
                #Consider using this instead....
                #$parseErrors = $null
                #$code = Get-Content $functionFile
                #$AST  = [System.Management.Automation.Language.Parser]::ParseInput($Code,[ref]$null,[ref]$parseErrors)
                #$parseErrors.Count  | Should Be 0

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

                       $result = [string[]](Import-PowerShellDataFile "$global:BuildFolder\NSTrainTime.psd1").AliasesToExport -contains $functionFileAlias
                       $result | Should -Be $true
                    }
                }
            }
        }
    }
}
