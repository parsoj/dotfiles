#!/bin/bash
input=$(cat)
target="${TMUX_PANE:-}"
window=$(tmux display-message -p -t "$target" '#W' 2>/dev/null || echo 'Session')
title=$(echo "$input" | jq -r '.title // "Needs your input"')
msg=$(echo "$input" | jq -r '.message // "Waiting for response"' | head -c 200)

# Capture tmux pane + look up the yabai window ID for this terminal
pane_id=$(tmux display-message -p -t "$target" '#{pane_id}' 2>/dev/null)
client_tty=$(tmux display-message -p -t "$target" '#{client_tty}' 2>/dev/null)
tty_key=$(echo "$client_tty" | tr '/' '_')
yabai_wid=$(cat "/tmp/ghostty-yabai/$tty_key" 2>/dev/null)

if [ -n "$yabai_wid" ] && [ -n "$pane_id" ]; then
    terminal-notifier \
        -title "ClaudeCode $title" \
        -subtitle "$window" \
        -message "$msg" \
        -sound default \
        -activate com.mitchellh.ghostty \
        -execute "yabai -m window --focus $yabai_wid 2>/dev/null; tmux select-pane -t '$pane_id' 2>/dev/null"
elif [ -n "$pane_id" ]; then
    terminal-notifier \
        -title "ClaudeCode $title" \
        -subtitle "$window" \
        -message "$msg" \
        -sound default \
        -activate com.mitchellh.ghostty \
        -execute "tmux select-pane -t '$pane_id' 2>/dev/null"
else
    terminal-notifier -title "ClaudeCode $title" -subtitle "$window" -message "$msg" -sound default
fi
