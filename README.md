# NSTrainTime 
[![Build Status](https://darkcrystal.visualstudio.com/_apis/public/build/definitions/3bfcd214-d277-4749-9b97-707e7a61b114/1/badge)](https://darkcrystal.visualstudio.com/NSTrainTime/_build/index?definitionId=1)

## PowerShell Module (v5+) for Dutch train times between two stations 
## Trein dienstregeling


**This module needs API credentials for the Dutch NS API**

Request API access [here](https://www.ns.nl/ews-aanvraagformulier/?0).
Once you have a username and password from that site, you should update the Powershell data file: `APICredential.psd1` with the correct information.

Once the module is loaded, the Get-NSTrain function shows the last and next few trains between the provided stations and their availability determined from the [Dutch NS API](https://www.ns.nl/en/travel-information/ns-api).  

**Why did I write this?**

I kept turning up at the train station after work only to find the train was delayed, then I was waiting at a train station when I could have been PowerShelling at work.  How could I solve this problem?  The answer was this a script that I would fire off around EoD at work.

Eventually, I then got fed up with typos, afterall maybe the train would in fact be on time, so time was precious!  Major props to [@bielawb](https://github.com/bielawb) for the help with tab expansion :) 

Then I went to PowerShell Conf EU [^1] and was inspired to put this all into a module and share!


```powershell
Import-Module NSTrainTime

Get-NSTrain -fromStation 'Amsterd... tab to complete' -toStation 'Duiven... tab to complete'
```

Good idea to output to Format-Table:

```powershell
Get-NSTrain -fromStation Amsterdam -toStation Duivendrecht | ft
```

[^1]: Definitely recommended!



