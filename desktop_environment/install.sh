##########################################################################################
# display manager

yay -S sddm
sudo systemctl enable sddm

##########################################################################################
# install XFCE4 as a backup DE

yay -S xfce4 xfce4-goodies

##########################################################################################
# install plasma and i3 env

# plasma
yay -S plasma kde-applications
mkdir -p ~/.config/plasma-workspace/env

rm ~/.config/plasma-workspace/env/wm.sh
ln -s ~/.dotfiles/desktop_environment/plasma_wm.sh ~/.config/plasma-workspace/env/wm.sh

# i3
yay -S i3-gaps
mkdir -p ~/.config/i3

rm ~/.config/i3/config
ln -s ~/.dotfiles/desktop_environment/i3_config ~/.config/i3/config

# rofi
yay -S rofi

##########################################################################################
# compton

yay -S compton
rm ~/.config/compton.conf
ln -s ~/.dotfiles/desktop_environment/compton.conf ~/.config/compton.conf

##########################################################################################
# X Windows configs

rm ~/.xinitrc
ln -s ~/.dotfiles/desktop_environment/xinitrc ~/.xinitrc

rm ~/.Xresources
ln -s ~/.dotfiles/desktop_environment/Xresources ~/.Xresources
