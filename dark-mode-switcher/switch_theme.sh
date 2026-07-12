#!/bin/bash
KITTY_THEMES=~/.config/kitty/themes
KITTY_CURRENT=~/.config/kitty/current-theme.conf

case "$1" in
  dark)
    cp "$KITTY_THEMES/catppuccin-frappe.conf" "$KITTY_CURRENT"
    ;;
  light)
    cp "$KITTY_THEMES/catppuccin-latte.conf" "$KITTY_CURRENT"
    ;;
  *)
    echo "Usage: $0 [dark|light]" >&2
    exit 1
    ;;
esac

# Reload kitty config in all windows
kill -SIGUSR1 $(pgrep -x kitty) 2>/dev/null || true
