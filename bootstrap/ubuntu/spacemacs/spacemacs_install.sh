sudo -i

############################################################
# Spacemacs installation

# base install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
apt install emacs

# source code pro font for spacemacs
mkdir -p ~/.fonts
cp ~/.dotfiles/spacemacs/fonts/source-code-pro/*.ttf ~/.fonts

# all-the-icons setup for neotree
cp ~/.dotfiles/spacemacs/fonts/all-the-icons/*.ttf ~/.fonts

################################################################################
# Run Spacemacs as a Daemon

# run emacs daemon (copy autostart file into autostart dir)
cp emacs.desktop ~/.config/autostart/

# set up emacs client launcher (using gsettings to edit gnome dconf)
/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding
'<Super>e'

/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name
'Emacs Client launcher'

/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command
'emacsclient -c -e "(shell)"'

/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

