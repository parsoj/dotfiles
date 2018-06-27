
# link in configs
mkdir -p ~/.i3
rm -rf ~/.i3/config ; ln -s ~/.dotfiles/i3/config ~/.i3/config
mkdir -p ~/.config/i3status
rm -rf ~/.config/i3status/config ; ln -s ~/.dotfiles/i3/i3status ~/.config/i3status/config

# install noto emoji fonts for i3 status bar
# yaourt -S noto-fonts-emoji



