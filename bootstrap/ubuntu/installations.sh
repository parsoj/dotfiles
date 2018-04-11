
############################################################
# OS control utilities
sudo apt install wmctrl

############################################################
# Coding Utilities
sudo apt install silversearcher-ag
sudo apt install markdown

################################################################################
# Spacemacs install

./applications/spacemacs/spacemacs_install.sh

################################################################################
# Applications

# Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable

# gnome tweak tool
# (can check dconf settings changedwith `dconf watch /` to move to gsettings)
sudo apt install gnome-tweak-tool

# install f.lux
./applications/flux/flux_install.sh

# install Rescue Time
./applications/rescuetime/rescuetime_install.sh
