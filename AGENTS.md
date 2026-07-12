# Config Repo Conventions

## Navigation Command Naming Scheme

Commands follow a `{scope}{target}` pattern:

| | **d** (directory) | **r** (root) | **f** (file) |
|---|---|---|---|
| **w** (workspace) | `wd` | `wr` | `wf` |
| **r** (repo) | `rd` | `rr` | |
| **d** (cwd children) | `dd` | | `df` |

Context-switching commands use a `g` (go) prefix:

| Command | Description |
|---|---|
| `gw` | Go to a workspace (fzf picker) |
| `gr` | Go to a repo (fzf picker) |
| `grt` | Go to Tennr repo directly |

Workspace management:

| Command | Description |
|---|---|
| `war` | Workspace add repo (fzf picker) |
| `wat` | Workspace add Tennr (worktree + gt track) |
| `wab` | Workspace add odd-bits |
| `wc` | Workspace create |
| `spinout` | Spin current repo changes into a new workspace |

When adding new navigation commands, follow this scheme. New scopes get a single-letter prefix, targets stay consistent (d/r/f/g).

## Codex Directory Layout

Source of truth for shared config lives in `~/.config/Codex/` (this repo, under `Codex/`). Two Codex profiles exist:

| Directory | Purpose |
|---|---|
| `~/.Codex/` | Work profile (Tennr) |
| `~/.Codex-personal/` | Personal profile |

Both profiles symlink shared files to this repo:

```
~/.Codex/settings.json       → ~/.config/Codex/settings.json
~/.Codex/settings.local.json → ~/.config/Codex/settings.local.json
~/.Codex/AGENTS.md           → ~/.config/Codex/AGENTS.md
~/.Codex/hooks/              → ~/.config/Codex/hooks/
~/.Codex/commands/           → ~/.config/Codex/commands/
~/.Codex/skills/             → ~/.config/Codex/skills/
~/.Codex/plugins/            → ~/.config/Codex/plugins/
~/.Codex/statusline.sh       → ~/.config/Codex/statusline.sh
```

(Same symlinks exist under `~/.Codex-personal/`.)

Each profile has its own `.Codex.json` (runtime state: startup count, tips, theme, editorMode). This file is NOT shared — it contains per-profile state that gets regenerated.

User preferences that live in `.Codex.json` (like `editorMode`) are enforced by `hooks/ensure-preferences.sh`, which runs on SessionStart. To change a preference, edit that hook script — don't edit `.Codex.json` directly.
