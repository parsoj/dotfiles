#!/bin/bash
# Stop event: update tmux tab state to idle (🟢).
# Desktop notifications are handled natively by cmux (claudeCodeIntegration);
# the old terminal-notifier scripts were removed when we went all-in on cmux.
input=$(cat)

echo "$input" | ~/.claude/hooks/tmux-tab-state.sh idle
