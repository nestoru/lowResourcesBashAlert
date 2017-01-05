# lowResourcesBashAlert
Minimalistic Linux low resources monitoring script. Not perfect but most likely good enough for 99% of cases out there ;-)

## Motivation
Amazon Web Services (AWS) is not providing an out of the box solution for such simple thing as monitoring HDD, Memory and CPU usage. CloudWatch demands still some coding and customization for something that IMO should be provided out of the box. We have Monit for Linux but if all you need is alerts when resources are low then this could be good enough. Prometheus is great but probably overkilling for a small startup.

## Install it


## Configure it
Use sed to set your variables, for example:

## Run it
cd /opt/scripts
./lowResourcesAlert.sh

## Schedule it
Cron it. For example:

## Too many alerts?
While you correct the issue: Comment cron line

When the issue has been corrected: Uncomment cron line
