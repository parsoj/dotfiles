#!/usr/bin/env bash
set -euo pipefail

# Dedicated one-shot kitty quick-access launcher.
# Runs the Fish Producer/Action/Flow launcher (`l`) and exits so the launcher
# instance is recreated on the next Cmd+Space.

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"
export SHELL="/opt/homebrew/bin/fish"
export QUICK_TERM=1
export KITTY_QUICK_ACCESS_LAUNCHER=1

exec /opt/homebrew/bin/fish -ic l
