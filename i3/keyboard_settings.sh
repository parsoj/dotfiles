################################################################################
# Key Remaps

# setting capslock as another escape
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

################################################################################
# Keyboard shortcuts

# workspace navigation shortcuts
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>k']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>j']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>h']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>l']"

# window control shortcuts

gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super><Alt>i']"

gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Super><Alt>k']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Super><Alt>j']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Super><Alt>l']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Super><Alt>h']"

gsettings set org.gnome.desktop.wm.keybindings move-to-corner-nw "['<Super><Alt>y']"
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-sw "['<Super><Alt>b']"
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-ne "['<Super><Alt>p']"
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-se "['<Super><Alt>.']"



