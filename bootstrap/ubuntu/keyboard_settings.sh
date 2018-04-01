################################################################################
# Key Remaps

# setting capslock as another escape
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

################################################################################
# Keyboard shortcuts

# workspace navigation shortcuts
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Alt>k']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Alt>j']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Alt>h']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Alt>l']"

# window control shortcuts

gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>u']"

gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>h']"

gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>l']"

