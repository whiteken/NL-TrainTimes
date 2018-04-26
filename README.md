# NSTrainTime 
[![Build Status](https://darkcrystal.visualstudio.com/_apis/public/build/definitions/3bfcd214-d277-4749-9b97-707e7a61b114/1/badge)](https://darkcrystal.visualstudio.com/NSTrainTime/_build/index?definitionId=1)

## PowerShell Module for Dutch train times between two stations (trein dienstregeling)



**This module needs API credentials for the Dutch NS API**
Request API access [here](https://www.ns.nl/ews-aanvraagformulier/?0)

Username and Password should be added to the Powershelldatafile: APICredential.psd1

Function to determine train availability from the Dutch NS API (https://www.ns.nl/en/travel-information/ns-api)
Use an Internet connected machine with access to (http://webservices.ns.nl/ns-api-treinplanner)



Got fed up turning up at the train station only to find the train was delayed, so I was waiting at a train station when I could have been PowerShelling at work...  How could I solve this problem?

This was originally written as a script that I would fire off around EoD at work.
Then I got fed up with typos, afterall maybe the train would in fact be on time, so time was precious! Major props to @bielawb for tab expansion :)

Then I went to PowerShell Conf EU (definitely recommended) and was inspired to put this all into a module and share...

```powershell
Import-Module NSTrainTime

Get-NSTrain -fromStation 'Amsterd... tab to complete' -toStation 'Duiven... tab to complete'
```

Good idea to output to Format-Table:

```powershell
Get-NSTrain -fromStation Amsterdam -toStation Duivendrecht | ft
```





