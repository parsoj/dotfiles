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

gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Alt>u']"

gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Alt>h']"

gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Alt>l']"

