#!/opt/homebrew/bin/fish

# Compatibility wrapper for Kitty keybindings/scripts.
# The reusable Producer/Action/Flow pieces live under ~/.config/fish/functions:
#   producer: workspace_list
#   action:   workspace_kitty_tab_open
#   flow:     workspace_pick_tab

exec /opt/homebrew/bin/fish -ic workspace_pick_tab
