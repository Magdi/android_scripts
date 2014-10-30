#!/bin/bash

DEV_LIST=$(adb devices | grep [0-9] | sed "s/device//g")
echo "devices list"
echo $DEV_LIST 
echo "--------------------------"
for deviceId in $DEV_LIST
do
	IP_LINE=$(adb -s $deviceId shell ip -f inet addr show wlan0 | grep inet | sed "s/[a-z]//g" | tr -d ' ')
	IFS='/' read -r IP garp <<< "$IP_LINE"
	echo "adding device $deviceId to wifi-adb with ip $IP"
	adb -s $deviceId tcpip 5555
	adb -s $deviceId connect $IP:5555
done
adb devices