# NSTrainTime 


|   | Dev | Master |
|----------|----------|----------|
| Build | [![Build Status](https://darkcrystal.visualstudio.com/NSTrainTime/_apis/build/status/whiteken.NSTrainTime?branchName=dev)](https://darkcrystal.visualstudio.com/NSTrainTime/_build/latest?definitionId=4&branchName=dev) | [![Build Status](https://darkcrystal.visualstudio.com/NSTrainTime/_apis/build/status/whiteken.NSTrainTime?branchName=master)](https://darkcrystal.visualstudio.com/NSTrainTime/_build/latest?definitionId=4&branchName=master) |

| | Production | Stats |
|----------|----------|----------|
| Release |[![PSGallery Version](https://img.shields.io/powershellgallery/v/NSTrainTime.svg?style=plastic&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/NSTrainTime/) | [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/NSTrainTime.svg?style=plastic&label=Downloads)](https://www.powershellgallery.com/packages/NSTrainTime/) |

## PowerShell Module (v5+) for Dutch train times between two stations 
## Trein dienstregeling

**How to use it:**

```powershell

Import-Module NSTrainTime

Get-NSTrainJourney -fromStation 'Amsterdam' -toStation 'Duivendrecht'

```

Returns full set of trains journeys from the api

```powershell

Get-NSTrainJourney -fromStation 'Amsterdam' -toStation 'Duivendrecht'

```

Tab completion is enabled on -fromStation and -toStation parameters so it's not necessary to know the full station name.  Type the first few letters and hit tab.
