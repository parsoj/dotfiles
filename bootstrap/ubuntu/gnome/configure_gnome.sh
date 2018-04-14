
############################################################
# OS control utilities
sudo apt -y install wmctrl

# gnome tweak tool
# (can check dconf settings changedwith `dconf watch /` to move to gsettings)
sudo apt -y install dconf-editor
sudo apt -y install gnome-tweak-tool
sudo apt -y install chrome-gnome-shell


# auto-hide the dock
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

################################################################################
# Install extensions


# Install "Hide top bar" extension
cd ~/.local/share/gnome-shell/extensions/
git clone https://github.com/mlutfy/hidetopbar.git hidetopbar@mathieu.bidon.ca
cd hidetopbar@mathieu.bidon.ca
make schemas
gnome-shell-extension-tool -e hidetopbar@mathieu.bidon.ca
gnome-shell --replace &

