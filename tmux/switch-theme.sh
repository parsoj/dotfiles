#!/bin/bash
# Switch catppuccin tmux theme.
# Called by tmux's client-dark-theme / client-light-theme hooks (DEC mode 2031),
# fired automatically by Ghostty and Kitty when macOS appearance changes.
flavor="$1"  # "frappe" or "latte"

PLUGIN_DIR="$HOME/.config/tmux/plugins/tmux"

# Update flavor option
tmux set -g @catppuccin_flavor "$flavor"

# Source the theme file with -ogq replaced by -g so it overrides already-set values
tmpfile=$(mktemp)
sed 's/set -ogq/set -g/g' "$PLUGIN_DIR/themes/catppuccin_${flavor}_tmux.conf" > "$tmpfile"
tmux source "$tmpfile"
rm -f "$tmpfile"

# Re-apply the catppuccin styling using the updated color variables
tmux source "$PLUGIN_DIR/catppuccin_tmux.conf"

# Force status bar background (catppuccin's -gF expand sometimes doesn't redraw)
bg=$(tmux show-options -gv @thm_mantle 2>/dev/null)
fg=$(tmux show-options -gv @thm_fg 2>/dev/null)
[ -n "$bg" ] && [ -n "$fg" ] && tmux set -g status-style "bg=${bg},fg=${fg}"

# Force full client redraw
tmux refresh-client

# Also update kitty's theme (kitty sends the DEC 2031 signal, so it's running outside tmux)
KITTY_THEME="$HOME/.config/kitty/themes/catppuccin-${flavor}.conf"
KITTY_CURRENT="$HOME/.config/kitty/current-theme.conf"
if [ -f "$KITTY_THEME" ]; then
    cp "$KITTY_THEME" "$KITTY_CURRENT"
    # Apply live to all running kitty instances
    kitty @ --to unix:/tmp/mykitty set-colors --all --configured "$KITTY_CURRENT" 2>/dev/null || true
fi
