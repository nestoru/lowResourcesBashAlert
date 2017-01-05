# lowResourcesBashAlert
Minimalistic Linux low resources monitoring script. Not perfect but most likely good enough for 99% of cases out there ;-)

## Motivation
Amazon Web Services (AWS) is not providing an out of the box solution for such simple thing as monitoring HDD, Memory and CPU usage. CloudWatch demands still some coding and customization for something that IMO should be provided out of the box. We have Monit for Linux but if all you need is alerts when resources are low then this could be good enough. Prometheus is great but probably overkilling for a small startup. NOte that all the below sections could be automated using Plain Old Bash Recipes that you can deploy with Remoto-IT.

## Install it
```
sudo apt -y install sendemail
cd
sudo mkdir -p /opt/scripts
sudo chown -R `logname`:`logname` /opt/scripts
cd /opt/scripts
curl -O https://raw.githubusercontent.com/nestoru/lowResourcesBashAlert/master/lowResourcesAlert.sh
chmod +x lowResourcesAlert.sh 
```
## Configure it
### Set your Thresholds
```
sed -i 's/^cpuLoadPercentageThreshold.*/cpuLoadPercentageThreshold=85/g' lowResourcesAlert.sh
sed -i 's/^memoryUsedPercentageThreshold.*/memoryUsedPercentageThreshold=85/g' lowResourcesAlert.sh
sed -i 's/^diskUsedPercentageThreshold.*/diskUsedPercentageThreshold=85/g' lowResourcesAlert.sh
```
### Set your SMTP details
```
sed -i 's/^smtpHost.*/smtpHost="smtp.sample.com"/g' lowResourcesAlert.sh
sed -i 's/^smtpFrom.*/smtpFrom="do_not_reply@sample.com"/g' lowResourcesAlert.sh
sed -i 's/^smtpTo.*/smtpTo="devops@sample.com"/g' lowResourcesAlert.sh
```
## Run it
```
cd /opt/scripts
./lowResourcesAlert.sh
```
## Schedule it to run every 5 minutes
```
crontabList=$(crontab -l 2> /dev/null | sed '/lowResourcesAlert.sh/d' || true)
echo -e "$crontabList" | echo -e "$crontabList\n*/5 * * * * /opt/scripts/lowResourcesAlert.sh > /dev/null" | crontab -
```
## Too many alerts?
While you correct the issue: Comment cron line

When the issue has been corrected: Uncomment cron line
