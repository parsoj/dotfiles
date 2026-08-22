# Old-mac migration: popup pool + config sync (2026-08)

Getting the old mac up to parity with the air. Written on the air just
before the move; everything referenced here is pushed.

## 0. Prereqs on the old mac

- **Architecture check first.** Everything in this config hardcodes
  `/opt/homebrew/...` (Apple Silicon). If the old mac is Intel, Homebrew
  lives at `/usr/local` and you must fix paths in
  `popup-terminal/config.toml` and `popup-terminal/ai-chat.sh` before
  anything works.
- Xcode command line tools (Swift toolchain — builds popup-terminal)
- `brew install go timg jq fish` (go builds quick-capture; timg is the
  cmd+opt+m map popup; jq is used by ai-chat.sh)
- Claude Code at `~/.local/bin/claude`, plus the `~/.claude-personal`
  profile dir (ai-chat.sh sets `CLAUDE_CONFIG_DIR` to it)

## 1. Config repo (~/.config)

```sh
cd ~/.config
gt sync
gt checkout skhd-hyper-chrome-binds   # tip of the current stack
```

The stack above master is `fish-scoped-dir-pickers` →
`skhd-hyper-chrome-binds` (dotfiles PRs #3/#4); either checkout the tip
or merge the stack first. This brings in the popup-terminal config,
ai-chat.sh, claude hooks/settings, cmux config, and the newer fish/skhd
setup.

Recreate the Claude profile symlinks per the table in `CLAUDE.md`
(`~/.claude/settings.json → ~/.config/claude/settings.json`, etc., for
both `~/.claude` and `~/.claude-personal`).

## 2. popup-terminal + quick-capture (the popup pool)

Source: `odd-bits` repo, branch `popup-pool` (PR #7, includes
uncommitted-until-now theme work the air's binaries were built from).

```sh
# in a workspace (repo_add odd-bits) or a plain clone:
gt checkout popup-pool
tools/terminal-popup/scripts/install.sh   # builds, installs to ~/.local/bin, loads launchd agent
tools/quick-capture/scripts/install.sh    # same for quick-capture + quick-notes-mirror agent
```

Both installers are idempotent and write their own launchd plists
(`io.oddbits.popup-terminal`, `io.oddbits.quick-notes-mirror`).

## 3. Loose ends the installers do NOT cover

- **cmd+space conflicts with Spotlight** — disable the Spotlight
  shortcut in System Settings → Keyboard → Shortcuts.
- **Map popup (cmd+opt+m)** expects
  `~/code/workspaces/popup-pool/map.png` — copy it over (it lives in the
  popup-pool workspace on the air, untracked).
- **quick-notes mirror** writes to `~/Obsidian/Inbox.md` — make sure the
  Obsidian vault exists at that path.
- **Grant permissions**: popup-terminal needs Accessibility /
  Input Monitoring for the global hotkeys — macOS will prompt on first
  summon; approve in System Settings → Privacy & Security.
- Reload config after edits:
  `launchctl kickstart -k gui/$(id -u)/io.oddbits.popup-terminal`
- Agent log if something's wrong:
  `~/.local/state/popup-terminal/agent.log`

## 4. Verify

- cmd+space → fish popup with `l` listing
- cmd+opt+a → Claude popup (personal profile, no trust dialog)
- cmd+opt+n / cmd+opt+shift+n → quick capture; entry lands in
  Obsidian Inbox.md via the mirror agent
- cmd+opt+m → map popup (after copying map.png)
