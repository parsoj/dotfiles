#!/bin/bash
# Sync tmux catppuccin flavor with current macOS appearance

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qx Dark; then
    tmux set -g @catppuccin_flavor "frappe"
else
    tmux set -g @catppuccin_flavor "latte"
fi

tmux source-file ~/.config/tmux/tmux.conf
