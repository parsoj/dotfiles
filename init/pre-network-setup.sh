
################################################################################
# FileVault

#$ cat > /dev/random
#[Type random letters for a long while, then press Control-D]

# enable FileVault
sudo fdesetup enable

#TODO maybe remove stuff below this (sloooooow wake up)
# force hibernation + destroy FileVault key on standby
sudo pmset -a destroyfvkeyonstandby 1
sudo pmset -a hibernatemode 25

# needed to prevent above settings from resulting in
# auto-wake & then shutdown (since FV key is missing)
sudo pmset -a powernap 0
sudo pmset -a standby 0
sudo pmset -a standbydelay 0
sudo pmset -a autopoweroff 0

################################################################################
# Firewall stuff

## Application-layer firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

### disable auto-whitelisting of built-in or signed binaries/Apps
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

### restart app-level firewall to take settings
sudo pkill -HUP socketfilterfw


## kernel-level firewall (just use pre-prepped file for now)
sudo pfctl -e -f pf.rules #FIXME fix this path

### INSTRUCTIONS:
### Use the following commands to use the firewall:
### sudo pfctl -e -f pf.rules to enable the firewall
### sudo pfctl -d to disable the firewall
### sudo pfctl -t blocklist -T add 1.2.3.4 to add hosts to a blocklist
### sudo pfctl -t blocklist -T show to view the blocklist
### sudo ifconfig pflog0 create to create an interface for logging
### sudo tcpdump -ni pflog0 to dump the packets


################################################################################
# Disable OSX services
## FIXME


## disable spotlight suggestions
### FIXME



################################################################################
# OSX usage preferences
#FIXME dock autohiding, smaller size, on right
#FIXME set caps lock key to "No Action" in keyboard prefs
