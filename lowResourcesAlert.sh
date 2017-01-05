#!/bin/bash -e
# /opt/scripts/lowResourcesAlert.sh
# @author: Nestor Urquiza
# @date: 20170105
# @description: Sends an email when any of the declared thresholds is reached
# @usage: Set thresholds and SMTP details. Run it and/or cron it

# Check dependencies
type sendEmail >/dev/null 2>&1 || (echo >&2 "ERROR: Please install sendEmail to use this script." && exit 1)

# Set your Thresholds
cpuLoadPercentageThreshold=
memoryUsedPercentageThreshold=
diskUsedPercentageThreshold=

# Set your SMTP details
smtpHost=
smtpFrom= 
smtpTo=

# Get current host name
hostname=$(hostname)

# Get current CPU Load Percentage
cpuLoadPercentage=`top -b -n1 | grep "Cpu" | awk '{print $2 + $4}'`
isCpuLoadAboveThreshold=`echo "" | awk "{print ($cpuLoadPercentage >= $cpuLoadPercentageThreshold)}"`
if [[ $isCpuLoadAboveThreshold -eq 1 ]]; then
  subject="[cpuLoadPercentage]"
  result="[cpuLoadPercentage: ${cpuLoadPercentage}\n"
fi

# Get current Memory Used Percentage
mem=$(free | grep Mem)
totalMem=$(echo $mem | awk '{print $2}')
availableMem=$(echo $mem | awk '{print $7}')
memoryUsedPercentage=`echo "" | awk "{print (1 - $availableMem / $totalMem) *100}"`
isMemoryUsedAboveThreshold=`echo "" | awk "{print ($memoryUsedPercentage >= $memoryUsedPercentageThreshold)}"`
if [[ $isMemoryUsedAboveThreshold -eq 1 ]]; then
  subject="${subject}[memoryUsedPercentage]"
  result="${result}[memoryUsedPercentage: ${memoryUsedPercentage}\n"
fi

# Get current HDD Used Percentage
disks=`df -l | awk '{if ($1 ~ /\/dev/) { print $1" "substr($5, 1, length($5)-1) }}'`
while read -r -a line; do
  disk=${line[0]}
  diskUsedPercentage=${line[1]}
  isDiskUsedAboveThreshold=`echo "" | awk "{print ($diskUsedPercentage >= $diskUsedPercentageThreshold)}"`
  if [[ $isDiskUsedAboveThreshold -eq 1 ]]; then
    subject="${subject}[diskUsedPercentage ${disk}]"
    result="${result}[diskUsedPercentage for ${disk}: ${diskUsedPercentage}\n"
  fi  
done <<< "$disks"

# Send email if needed
if [[ ! -z $result ]]; then
  subject="$hostname threshold(s) matched: $subject"
  result="$hostname matched resources(s):\n${result}"
  echo -e $result | sendEmail -f $smtpFrom -t $smtpTo -s $smtpHost -u $subject > /dev/null
fi
