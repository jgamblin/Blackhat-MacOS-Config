# Blackhat MacOS Config
A simple shell script to configure your MacBook to some of the most commonly recommended settings for the worlds most dangerous hacking conferences (Blackhat/Defcon) or everyday life.

## What It Does:
- Deletes Saved Wireless Networks.
- ~~Disable Wireless Network Auto Join.~~ < This cant be done programmatically. `¯\_(ツ)_/¯`
- Require Password Immediately After Sleep
- Turns On Firewall.
  - Enables Stealth Mode
- Installs Needed System Updates.
- Enables Full Disk Encryption.

Note: Script Will Prompt For Password If Not Root.

## Usage:
- Review for your preferences and comment out options **You** dont want.
- Set `homessid` and `workssid` variable to stop from deleting those!

To Run:  
```
chmod +x blackhat-macos-config.sh
./blackhat-macos-config.sh
```

## Important Notice
I likely don't know what I am doing and this could be done faster, better and simpler some other way. These scripts could also break your MacBook and make you cry.
