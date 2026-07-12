#!/usr/bin/env bash
set -euo pipefail

# Kitty key mappings launched from the macOS app may not inherit the Homebrew
# PATH from an interactive shell.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"
export SHELL="/opt/homebrew/bin/fish"

if command -v ipython >/dev/null 2>&1; then
  exec ipython
fi

if /opt/homebrew/bin/python3 -c 'import IPython' >/dev/null 2>&1; then
  exec /opt/homebrew/bin/python3 -m IPython
fi

if command -v pipx >/dev/null 2>&1; then
  exec pipx run ipython
fi

echo "ipython is not installed; falling back to python3" >&2
exec /opt/homebrew/bin/python3
