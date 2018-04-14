
# base install
wget https://www.rescuetime.com/installers/rescuetime_current_amd64.deb
sudo dpkg -i rescuetime_current_amd64.deb
sudo apt update
sudo apt -y install rescuetime
sudo apt -f install

rm rescuetime_current_amd64.deb

# start rescuetime on login
mkdir -p ~/.config/autostart
cp rescuetime.desktop ~/.config/autostart/
