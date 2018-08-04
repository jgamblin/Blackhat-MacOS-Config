#!/bin/bash
SECONDS=0

#Check if running as root and if not elevate
amiroot=$(sudo -n uptime 2>&1| grep -c "load")
if [ "$amiroot" -eq 0 ]
then
    printf "Blackhat MacOS Config Require Root Access. Please Enter Your Password.\n"
    sudo -v
    printf "\n"
fi

#Delete Saved SSIDs For Security
#Be Sure To Set Home And Work SSID for ease of use.
printf "Deleting Saved Wireless networks.\n"
homessid="AddMe"
workssid="AddMe"
IFS=$'\n'
for ssid in $(networksetup -listpreferredwirelessnetworks en0 | grep -v "Preferred networks on en0:" | grep -v $homessid | grep -v $workssid | sed "s/[\	]//g")
do
    networksetup -removepreferredwirelessnetwork en0 "$ssid"  > /dev/null 2>&1
done

#Enabling Firevault:
printf "Enabling FDE.\n"
fdesetup enable  > /dev/null 2>&1

#Enable Firewall:
printf "Enabling Firewall.\n"
defaults write /Library/Preferences/com.apple.alf globalstate 1  > /dev/null 2>&1

#Install Updates.
printf "Installing needed updates.\n"
softwareupdate -i -a > /dev/null 2>&1

#Finishing Up.
timed="$((SECONDS / 3600)) Hours $(((SECONDS / 60) % 60)) Minutes $((SECONDS % 60)) seconds"
printf "Maid Service Took %s this time. Dont Forget To Tip!\n" "$timed"
