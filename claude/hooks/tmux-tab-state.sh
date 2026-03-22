#!/bin/bash
cat > /dev/null  # consume hook JSON payload
state="$1"
target="${TMUX_PANE:-}"
[ -z "$target" ] && exit 0

window=$(tmux display-message -p -t "$target" '#{window_id}' 2>/dev/null)
[ -z "$window" ] && exit 0

raw=$(tmux display-message -p -t "$window" '#W' 2>/dev/null)
# Strip any existing indicator
name="${raw% 🟢}"
name="${name% 🔴}"
name="${name% 🔵}"
name="${name% 🟣}"

lock="/tmp/tmux-claude-monitoring-${window}"

case "$state" in
  working)    tmux rename-window -t "$window" "$name 🔵" ;;
  waiting)    tmux rename-window -t "$window" "$name 🔴" ;;
  monitoring) tmux rename-window -t "$window" "$name 🟣" ;;
  idle)
    # If monitoring lock exists, show 🟣 instead of 🟢
    if [ -f "$lock" ]; then
      tmux rename-window -t "$window" "$name 🟣"
    else
      tmux rename-window -t "$window" "$name 🟢"
    fi
    ;;
  clear) tmux rename-window -t "$window" "$name" ;;
  *)     exit 0 ;;
esac
