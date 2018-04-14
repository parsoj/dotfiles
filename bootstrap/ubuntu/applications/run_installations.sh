
# yak yak - desktop client for gHangouts
sudo snap install yakyak

# Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt -y install google-chrome-stable

# Spacemacs
./spacemacs/install.sh

# Rescue Time
./rescuetime/install.sh
