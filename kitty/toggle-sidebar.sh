#!/usr/bin/env bash
set -euo pipefail

# Toggle a per-tab kitty "sidebar" window running a dedicated terminal file
# explorer. Intended to be launched from kitty.conf with --cwd=current.

kitty_at() {
  if [[ -n "${KITTY_LISTEN_ON:-}" ]]; then
    kitty @ --to "$KITTY_LISTEN_ON" "$@"
  else
    kitty @ "$@"
  fi
}

state="$(kitty_at ls)"

# Prefer the active tab in the focused OS window, falling back to the first
# active tab if kitty does not report is_focused for some reason.
active_tab_id="$(jq -r '([.[] | select(.is_focused == true) | .tabs[] | select(.is_active == true) | .id] + [.[] | .tabs[] | select(.is_active == true) | .id])[0]' <<<"$state")"

if [[ -z "$active_tab_id" || "$active_tab_id" == "null" ]]; then
  exit 1
fi

sidebar_id="$(jq -r --argjson tab_id "$active_tab_id" '
  .[] | .tabs[] | select(.id == $tab_id) | .windows[] |
  select(.user_vars.kitty_sidebar == "1") | .id
' <<<"$state" | head -n 1)"

# If this tab already has a sidebar, close it.
if [[ -n "$sidebar_id" && "$sidebar_id" != "null" ]]; then
  kitty_at close-window --match "id:$sidebar_id" --ignore-no-match
  exit 0
fi

find_workspace_root() {
  local dir="$PWD"
  local home="$HOME"

  while [[ "$dir" != "/" && "$dir" != "$home" ]]; do
    if [[ -f "$dir/.workspace.json" ]]; then
      printf '%s\n' "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done

  if [[ -f "$dir/.workspace.json" ]]; then
    printf '%s\n' "$dir"
    return 0
  fi

  git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || printf '%s\n' "$PWD"
}

workspace_root="$(find_workspace_root)"
# Pick a terminal file explorer that behaves like a traditional single-pane
# tree sidebar: expanding a directory shows nested files inline and indented.
# Broot is a much better fit for this than yazi's multi-pane browser model.
if command -v broot >/dev/null 2>&1; then
  explorer=(broot --tree --sort-by-type-dirs-first --trim-root --no-sizes --no-permissions --no-dates "$workspace_root")
elif command -v br >/dev/null 2>&1; then
  explorer=(br --tree --sort-by-type-dirs-first --trim-root --no-sizes --no-permissions --no-dates "$workspace_root")
elif command -v lf >/dev/null 2>&1; then
  explorer=(lf "$workspace_root")
elif command -v ranger >/dev/null 2>&1; then
  explorer=(ranger "$workspace_root")
elif command -v nnn >/dev/null 2>&1; then
  explorer=(nnn "$workspace_root")
else
  explorer=(/bin/sh -lc 'printf "No traditional file explorer found.\n\nRecommended:\n  brew install broot\n\nAlternatives:\n  brew install lf ranger nnn\n\nPress Enter to close."; read _')
fi

# Otherwise open a narrow split. The script itself is launched with
# --cwd=current, so $PWD is the directory from the source window.
# We allow the new window to take focus briefly so move_window operates on it
# reliably, then restore focus to the previously active window.
new_id="$(kitty_at launch \
  --match "id:$active_tab_id" \
  --type=window \
  --location=vsplit \
  --bias=25 \
  --cwd "$PWD" \
  --var kitty_sidebar=1 \
  --title "kitty-sidebar" \
  "${explorer[@]}")"

# Make sure operations apply to the sidebar, force it left, and shrink it.
# The extra resize fixes cases where kitty's splits layout gives the new pane
# most of the space after reordering.
kitty_at focus-window --match "id:$new_id" >/dev/null 2>&1 || true
kitty_at action "move_window left" >/dev/null 2>&1 || true
kitty_at resize-window --match "id:$new_id" --axis horizontal --increment -80 >/dev/null 2>&1 || true
kitty_at resize-window --match "id:$new_id" --axis horizontal --increment -20 >/dev/null 2>&1 || true

# Return focus to the main pane.
kitty_at focus-window --match recent:1 >/dev/null 2>&1 || true
