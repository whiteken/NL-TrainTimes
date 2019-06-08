# NSTrainTime 
[![Build Status](https://darkcrystal.visualstudio.com/_apis/public/build/definitions/3bfcd214-d277-4749-9b97-707e7a61b114/1/badge)](https://darkcrystal.visualstudio.com/NSTrainTime/_build/index?definitionId=1)

## PowerShell Module (v5+) for Dutch train times between two stations 
## Trein dienstregeling

**This module needs API credentials for the Dutch NS API**

Request API access [here](https://www.ns.nl/ews-aanvraagformulier/?0).
Once you have a username and password from that site, you should update the Powershell data file: `APICredential.psd1` with the correct information.

Once the module is loaded, the Get-NSTrainJourney function shows the last and next few trains between the provided stations and their availability determined from the [Dutch NS API](https://www.ns.nl/en/travel-information/ns-api).  

**How to use it:**

```powershell

Import-Module NSTrainTime

Get-NSTrainJourney -fromStation 'Amsterd... tab to complete' -toStation 'Duiven... tab to complete'

Returns full set of trains journeys from the api - usually 21.

Get-NSTrainJourney -fromStation 'Amsterd... tab to complete' -toStation 'Duiven... tab to complete' -Next 2

Returns only the next 2 trains based on current time.

```

