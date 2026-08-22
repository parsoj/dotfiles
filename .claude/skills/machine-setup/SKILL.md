---
name: machine-setup
description: Bootstrap or repair a Mac to Jeff's fully configured state — brew packages, yabai, skhd, popup pool, claude profiles, launchd agents — with health checks. Use when setting up a new machine, migrating machines, or when the user says "set this machine up", "get yabai/skhd working", or "run a health check on my setup".
---

# Machine setup & health

Bring an Apple Silicon Mac to a healthy, fully configured state matching
Jeff's setup, or diagnose/repair an existing one. Work phase by phase,
**verify each phase before moving on**, and finish with the health-check
report. On an already-configured machine you can run just the health
check and repair what fails.

Ask before anything needing `sudo` or that overwrites existing user data.
Everything else: just do it.

## Ground rules

- This repo **is** `~/.config` — cloning it there IS the config install.
  Tools (yabai, skhd, fish, kitty, ghostty, nvim, tmux…) read their XDG
  paths natively; no symlink farm, no stow.
- `osx/bootstrap.sh` and `osx/apply_configs.sh` are **legacy/stale**
  (Intel brew path, symlinks to a deleted `app_settings/` dir). Do NOT
  run them wholesale; use the phases below. `osx/Brewfile` is current.
- Apple Silicon only: everything hardcodes `/opt/homebrew`.
- Graphite rules apply here too: `gt` for all git operations.

## Phase 0 — Preflight

1. `uname -m` → must be `arm64`.
2. Xcode CLT present (`xcode-select -p`); install if missing (needed for
   swift/go builds later).
3. This repo cloned at `~/.config` (github.com/parsoj/dotfiles), on
   `master`, up to date (`gt sync`).
4. `~/.local/bin` exists and is on PATH.

## Phase 1 — Homebrew + packages

1. Install Homebrew if `/opt/homebrew/bin/brew` missing.
2. `brew bundle --file ~/.config/osx/Brewfile` (includes yabai, skhd,
   jq, fish, and the rest).
3. Extras not in the Brewfile yet: `brew install timg go` (popup pool
   deps). If they're missing from the Brewfile, add them and commit.
4. Make fish the login shell if it isn't: `/opt/homebrew/bin/fish` in
   `/etc/shells`, then `chsh -s /opt/homebrew/bin/fish` (ask first —
   needs sudo/password).

## Phase 2 — yabai (window management)

Config: `~/.config/yabai/yabairc` (read natively). Service runs as a
launchd agent — on the reference machine the plist is
`~/Library/LaunchAgents/com.asmvik.yabai.plist` running
`/opt/homebrew/bin/yabai` (RunAtLoad, KeepAlive, ProcessType
Interactive). `~/.config/yabai/yabai.plist` is a template — copy it,
keep the label consistent with the filename, and fix the binary path to
`/opt/homebrew/bin/yabai` if needed. `yabai/justfile` has recipes for
all of this (`just link`, `just start`, `just status`, sudoers helper).

1. Install plist → `launchctl bootstrap gui/$(id -u) <plist>`.
2. Grant **Accessibility** permission when macOS prompts (user action —
   System Settings → Privacy & Security → Accessibility).
3. Scripting addition (only if the yabairc uses it): needs a sudoers
   entry — generate with `just -f ~/.config/yabai/justfile
   get-sudoers-entry`, have Jeff install it, then `sudo yabai --load-sa`.
   Skip if SIP makes this moot and the config works without it.
4. Verify: `yabai -m query --windows` returns JSON; open two windows and
   confirm tiling.
5. Symlink helper scripts: `just -f ~/.config/yabai/justfile
   link-scripts` (links `yabai/scripts/bin/*` into `~/.local/bin`).

## Phase 3 — skhd (hotkeys)

Config: `~/.config/skhd/skhdrc` (read natively). Reference machine runs
it as launchd agent `com.koekeishiya.skhd` executing
`/opt/homebrew/bin/skhd`; `brew services start skhd` produces an
equivalent agent and is fine.

1. Start the service.
2. Grant **Accessibility** and **Input Monitoring** when prompted.
3. Verify: a bind from skhdrc works (e.g. hyper ctrl+alt+cmd+b → Chrome
   work-profile window). `skhd --observe` echoes keypresses if
   debugging.
4. Gotcha: Chrome profile directory names (`Default`, `Profile 1`) are
   per-machine. Confirm which is the tennr work profile
   (`ls ~/Library/Application Support/Google/Chrome/*/Preferences` +
   grep for account) and fix `skhd/skhdrc` if reversed.

## Phase 4 — Popup pool (popup-terminal + quick-capture)

Full detail in `docs/old-mac-migration.md`. Summary:

1. Clone/pull `odd-bits` (github.com/parsoj/odd-bits) on `main` — via
   `repo_add` if the workspace tooling is set up, plain clone otherwise.
2. `tools/terminal-popup/scripts/install.sh` — builds, installs
   `popup-terminal`/`popupctl` to `~/.local/bin`, loads launchd agent
   `io.oddbits.popup-terminal`.
3. `tools/quick-capture/scripts/install.sh` — same for `quick-capture`
   + WatchPaths agent `io.oddbits.quick-notes-mirror`.
4. Config already came with this repo (`popup-terminal/config.toml`,
   `ai-chat.sh`).
5. Loose ends: disable Spotlight's cmd+space shortcut; copy `map.png`
   to `~/code/workspaces/popup-pool/` (untracked, lives on the old
   machine); ensure `~/Obsidian/Inbox.md` exists for the mirror; grant
   Accessibility on first summon.
6. Verify: cmd+space → fish popup; cmd+opt+n capture lands in
   Inbox.md; cmd+opt+a → claude chat.

## Phase 5 — Claude Code profiles

Two profiles, both symlinking shared config into this repo (exact table
in `CLAUDE.md` at repo root): for EACH of `~/.claude` and
`~/.claude-personal`, symlink `settings.json`, `settings.local.json`,
`CLAUDE.md`, `hooks/`, `commands/`, `skills/`, `plugins/`,
`statusline.sh` → the corresponding paths under `~/.config/claude/`.
Do not copy or share `.claude.json` (per-profile runtime state).
`ai-chat.sh` requires `~/.claude-personal` to exist and `claude` at
`~/.local/bin/claude`.

## Phase 6 — Remaining agents & desktop

- **dark-notify**: `~/Library/LaunchAgents/com.jeff.darknotify.plist`
  runs `/opt/homebrew/bin/dark-notify -c
  ~/.config/dark-mode-switcher/switch_theme`. Create if missing.
- Fonts: `osx/install_fonts.sh`.
- Dock: `osx/dock_defaults.sh` (review before running).
- Fish plugins: `fisher update` if fisher present (`fish/fish_plugins`
  is the manifest).
- Workspace tooling expects `~/code/repos/` (canonical clones incl.
  `workspace-home`) and `~/code/workspaces/`; see CLAUDE.md workspace
  architecture section before creating anything by hand.

## Health check (run last, or standalone)

Report pass/fail per line, then fix failures:

```
launchctl list | grep -E "yabai|skhd|popup-terminal|quick-notes|darknotify"   # all present, status 0
yabai -m query --spaces >/dev/null && echo yabai-ok
pgrep -x skhd && echo skhd-ok
popupctl popup -- /bin/echo hi   # popup summons
test -x ~/.local/bin/quick-capture && echo qc-ok
readlink ~/.claude/settings.json | grep -q .config/claude && echo claude-work-ok
readlink ~/.claude-personal/settings.json | grep -q .config/claude && echo claude-personal-ok
brew bundle check --file ~/.config/osx/Brewfile
echo $SHELL | grep -q fish && echo shell-ok
```

Plus manual: one yabai tiling action, one skhd bind, one popup summon,
one quick-capture → Inbox.md round trip. Summarize what passed, what
was repaired, and anything needing Jeff's hands (permissions dialogs,
sudoers, passwords).
