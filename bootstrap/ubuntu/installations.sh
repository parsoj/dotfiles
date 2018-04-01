
############################################################
# OS control utilities
sudo apt install wmctrl

################################################################################
# Spacemacs install

./applications/spacemacs/spacemacs_install.sh

############################################################
# Coding Utilities
sudo apt install git
sudo apt install silversearcher-ag
sudo apt install markdown

################################################################################
# Applications

# Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt update
sudo apt install google-chrome-stable

# Albert
wget -nv -O Release.key https://build.opensuse.org/projects/home:manuelschneid3r/public_key
sudo apt-key add - < Release.key
sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
sudo apt update
sudo apt install albert

# gnome tweak tool
# (can check dconf settings changedwith `dconf watch /` to move to gsettings)
sudo apt install gnome-tweak-tool

# TODO rescue time script (install and login item)

