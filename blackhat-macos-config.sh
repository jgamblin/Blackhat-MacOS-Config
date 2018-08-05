#!/bin/bash

homessid="AddMe"
workssid="AddMe"

SECONDS=0

RED='\033[0;31m'
NC='\033[0m'

#Check if running as root and if not elevate
sudo -nv 2>>/dev/null
if [ $? -ne 0 ]; then
    printf "Black Hat macOS Config requires root access.\n"
    printf "Please enter your password, or run 'sudo -v' first.\n"
    sudo -v

    #Validate we can sudo now
    if [ $? -ne 0 ]; then
      printf "\n"
      printf "Still not root. Exiting.\n"
      exit
    fi
    printf "\n"
fi

#Delete Saved SSIDs For Security
#Be Sure To Set Home And Work SSID for ease of use.
printf "Deleting saved Wi-Fi networks.\n"
IFS=$'\n'
for ssid in $(networksetup -listpreferredwirelessnetworks en0 | grep -v "Preferred networks on en0:" | grep -v $homessid | grep -v $workssid | sed "s/[\	]//g")
do
    networksetup -removepreferredwirelessnetwork en0 "$ssid" > /dev/null 2>&1
done


#Enable Password Login:
printf "Require Password Immediately After Sleep or Screen Saver Begins.\n"
defaults write com.apple.screensaver askForPassword 1 > /dev/null 2>&1
defaults write com.apple.screensaver askForPasswordDelay 0 > /dev/null 2>&1

#Enable Firewall:
printf "Enabling Firewall.\n"

#This is a more "open" firewall config
#https://discussions.apple.com/thread/3148672
defaults write /Library/Preferences/com.apple.alf globalstate 1  > /dev/null 2>&1

#This is a more "strict" firewall config
#defaults write /Library/Preferences/com.apple.alf globalstate 2  > /dev/null 2>&1

printf "Enabling Stealth Firewall Mode.\n"
defaults write /Library/Preferences/com.apple.alf stealthenabled 1 > /dev/null 2>&1


#Install Updates.
printf "Installing needed updates.\n"
softwareupdate -i -a > /dev/null 2>&1


#Check if System Integrity Protection is enabled
printf "Verifying System Integrity Protection (SIP) is enabled.\n"
csrutil=$(csrutil status)
if [[ $csrutil = *"disabled"* ]]; then
  printf "${RED}WARNING: System Integrity Protection is disabled!${NC}\n"
  printf "To enable, you must boot into recovery mode and enable:\n"
  printf " - restart\n"
  printf " - during bootup, hold Cmd+R\n"
  printf " - click Utilities->Terminal\n"
  printf " - run: csrutil enable\n"
  printf " - run: reboot # to get back into standard macOS\n"
fi

#Enabling Firevault:
printf "Enabling FDE.\n"
fdesetup enable  > /dev/null 2>&1


#Finishing Up.
timed="$((SECONDS / 3600)) Hours $(((SECONDS / 60) % 60)) Minutes $((SECONDS % 60)) seconds"
printf "It took %s to help get your Mac ready for Black Hat.\n" "$timed"
