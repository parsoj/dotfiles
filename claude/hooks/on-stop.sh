#!/bin/bash
# Wrapper for Stop event: update tmux tab state first, then notify.
# Sequential order ensures the notification subtitle shows the correct indicator.
input=$(cat)

# Update tab state to idle (🟢) first
echo "$input" | ~/.claude/hooks/tmux-tab-state.sh idle

# Then send notification (reads window name which now has 🟢)
echo "$input" | ~/.claude/hooks/notify-stop.sh
