
set -e


# this should already be installed - but its a dependency for using Nord VPN
sudo apt -y install ca-certificates

sudo apt -y install openvpn

cd /etc/openvpn

# Download NordVPN OpenVpn config files
sudo wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip

sudo unzip ovpn.zip

sudo rm ovpn.zip


