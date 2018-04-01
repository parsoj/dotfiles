# run this script with sudo access
sudo -i

############################################################
# OS control utilities
apt install wmctrl

############################################################
# Coding Utilities
apt install git
apt install silversearcher-ag
apt install markdown

#################################################################
# Spacemacs install

# base install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
apt install emacs

# run as deamon on startup
echo "emacs --daemon" >> /etc/profile.d/emacs_daemon.sh
chmod +x /etc/profile.d/emacs_daemon.sh

# source code pro font for spacemacs
mkdir -p ~/.fonts
cp ~/.dotfiles/spacemacs/fonts/source-code-pro/*.ttf ~/.fonts

# all-the-icons setup for neotree
cp ~/.dotfiles/spacemacs/fonts/all-the-icons/*.ttf ~/.fonts

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
apt install gnome-tweak-tool

