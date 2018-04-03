
# base install
wget https://www.rescuetime.com/installers/rescuetime_current_amd64.deb
sudo dpkg -i rescuetime_current_amd64.deb

# start rescuetime on login
cp rescuetime.desktop ~/.config/autostart/
