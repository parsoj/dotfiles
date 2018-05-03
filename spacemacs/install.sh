
#############################################################
# Spacemacs installation

# base install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
sudo apt -y install emacs

# link in spacemacs config
rm ~/.spacemacs ; ln -s ~/.dotfiles/spacemacs/spacemacs_config ~/.spacemacs

# source code pro font for spacemacs
mkdir -p ~/.fonts
cp ~/.dotfiles/spacemacs/fonts/source-code-pro/*.ttf ~/.fonts

# all-the-icons setup for neotree
cp ~/.dotfiles/spacemacs/fonts/all-the-icons/*.ttf ~/.fonts

################################################################################
# Run Spacemacs as a Daemon

# run emacs daemon (copy autostart file into autostart dir)
mkdir -p ~/.config/autostart
cp emacs.desktop ~/.config/autostart/

# set up emacs client launcher (using gsettings to edit gnome dconf)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'EmacsClient Launcher'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Super>e'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'emacsclient -c -e \"(shell)\"'"

################################################################################

# spacemacs support utilities
sudo apt -y install silversearcher-ag
sudo apt -y install markdown
