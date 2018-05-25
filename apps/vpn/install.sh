
set -e


# this should already be installed - but its a dependency for using Nord VPN
sudo apt -y install ca-certificates
sudo apt -y install openvpn


# Download NordVPN OpenVpn config files
cd /etc/openvpn
sudo wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
sudo unzip ovpn.zip
sudo rm ovpn.zip

# install the nm component for openvpn
sudo apt-get install network-manager-openvpn
sudo apt-get install network-manager-openvpn-gnome

sudo systemctl restart network-manager

