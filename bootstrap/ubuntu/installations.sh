# run this script with sudo access
sudo -i

############################################################
# OS control utilities
apt install wmctrl

################################################################################
# Spacemacs install

./spacemacs/spacemacs_install.sh

############################################################
# Coding Utilities
apt install git
apt install silversearcher-ag
apt install markdown

################################################################################
# Applications

# Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
apt update
apt install google-chrome-stable

# Albert
wget -nv -O Release.key https://build.opensuse.org/projects/home:manuelschneid3r/public_key
apt-key add - < Release.key
sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
apt update
apt install albert

# flux
add-apt-repository ppa:nathan-renniewaldock/flux
apt update
apt install fluxgui

# gnome tweak tool
# (can check dconf settings changedwith `dconf watch /` to move to gsettings)
apt install gnome-tweak-tool

