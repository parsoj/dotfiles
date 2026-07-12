#!/usr/bin/env bash
set -euo pipefail

LOG="/Users/jeff/.cache/kitty/quick-access-shell.log"
mkdir -p "$(dirname "$LOG")"

{
  echo "--- $(date '+%Y-%m-%d %H:%M:%S') quick-access-shell.sh start ---"
  echo "pid=$$ ppid=$PPID"
  echo "argv=$*"
  echo "initial PATH=${PATH:-}"
} >>"$LOG" 2>&1

# Kitty key mappings launched from the macOS app may not inherit the Homebrew
# PATH from an interactive terminal shell.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"
export SHELL="/opt/homebrew/bin/fish"
export KITTY_QUICK_ACCESS_LOG="$LOG"

{
  echo "fixed PATH=$PATH"
  echo "fish=$SHELL"
  echo "brew=$(command -v brew || true)"
  echo "direnv=$(command -v direnv || true)"
  echo "starship=$(command -v starship || true)"
  echo "l=$(command -v l || true)"
} >>"$LOG" 2>&1

# Start the quick-access terminal by showing the workspace/repo launcher (`l`),
# then leave a normal interactive fish shell behind.
exec /opt/homebrew/bin/fish -ic '
  echo "fish startup reached at "(date "+%Y-%m-%d %H:%M:%S") >> $KITTY_QUICK_ACCESS_LOG
  echo "fish PATH=$PATH" >> $KITTY_QUICK_ACCESS_LOG
  echo "fish l="(command -v l) >> $KITTY_QUICK_ACCESS_LOG
  l
  set l_status $status
  echo "l exited with status $l_status at "(date "+%Y-%m-%d %H:%M:%S") >> $KITTY_QUICK_ACCESS_LOG
  exec /opt/homebrew/bin/fish
'
