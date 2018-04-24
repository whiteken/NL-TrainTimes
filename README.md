# NSTrainTime
PowerShell Module for Dutch train times between two stations (trein dienstregeling)

Got fed up turning up at the train station only to find the train was delayed, so I was waiting at a train station when I could have been PowerShelling at work...  How could I solve this problem?

This was originally written as a script that I would fire off around EoD at work.
Then I got fed up with typos, afterall maybe the train would in fact be on time, so time was precious! Major props to @bielawb for tab expansion :)

Then I went to PowerShell Conf EU (definitely recommended) and was inspired to put this all into a module and share...

Import-Module NSTrainTime
Get-NSTrain -fromStation 'Amsterd... tab to complete' -toStation 'Duiven... tab to complete'

Good idea to output to Format-Table:

Get-NSTrain -fromStation Amsterdam -toStation Duivendrecht | ft