# set up fw
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# prevent auto-whitelisting of signed and built-in stuff
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

# restart the firewall
sudo pkill -HUP socketfilterfw

# enable kernel-level fw
sudo pfctl -e -f pf.rules


