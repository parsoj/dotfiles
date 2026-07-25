#!/bin/sh
# Launcher for the cmd+opt+a popup AI chat (see config.toml).
# Fresh temp dir per chat; pre-seeds the trust/onboarding entry in the
# personal profile's .claude.json so a never-seen directory doesn't
# retrigger the first-run flow on every summon.
set -eu

export CLAUDE_CONFIG_DIR="$HOME/.claude-personal"
JQ=/opt/homebrew/bin/jq

dir=$(mktemp -d /tmp/ai-popup-XXXXXXXX)
cd "$dir"
real=$(pwd -P) # claude keys projects by resolved path (/private/tmp/...)

cfg="$CLAUDE_CONFIG_DIR/.claude.json"
tmp=$(mktemp)
"$JQ" --arg d "$real" '.projects[$d] = {
  allowedTools: [],
  history: [],
  hasTrustDialogAccepted: true,
  hasCompletedProjectOnboarding: true
}' "$cfg" >"$tmp" && mv "$tmp" "$cfg"

exec "$HOME/.local/bin/claude"
