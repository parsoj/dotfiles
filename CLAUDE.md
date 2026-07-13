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
| `workspace_remove <path>` | Remove a workspace (child worktrees + root worktree + branches) |
| `workspace_sync [path]` | Materialize child repos from the manifest (also fires via post-checkout hook) |
| `workspace_fork <name>` | Fork current workspace: children branched off source HEADs, dirty state copied |
| `/wsfork <name>` | Claude skill: workspace_fork + forked claude session in a new cmux workspace |

When adding new navigation commands, follow this scheme. New scopes get a single-letter prefix, targets stay consistent (d/r/f/g).

### Workspace architecture (2026-07)

Every workspace root under `~/code/workspaces/` is a git worktree of the shell repo `~/code/repos/workspace-home` (branch = sanitized workspace name), and `.workspace.json` is a tracked manifest (repos, branches, created timestamp — plus pre-existing fields like `obsidian_project`). Child repos are worktrees of `~/code/repos/*`, deliberately untracked-and-NOT-gitignored in workspace-home. Never `mkdir` or `rm -rf` workspace roots directly — use the verbs above, or stale worktree registrations pile up. Full design: `docs/workspace-shell-repo-design.md`.

## Claude Code Directory Layout

Source of truth for shared config lives in `~/.config/claude/` (this repo, under `claude/`). Two Claude Code profiles exist:

| Directory | Purpose |
|---|---|
| `~/.claude/` | Work profile (Tennr) |
| `~/.claude-personal/` | Personal profile |

Both profiles symlink shared files to this repo:

```
~/.claude/settings.json       → ~/.config/claude/settings.json
~/.claude/settings.local.json → ~/.config/claude/settings.local.json
~/.claude/CLAUDE.md           → ~/.config/claude/CLAUDE.md
~/.claude/hooks/              → ~/.config/claude/hooks/
~/.claude/commands/           → ~/.config/claude/commands/
~/.claude/skills/             → ~/.config/claude/skills/
~/.claude/plugins/            → ~/.config/claude/plugins/
~/.claude/statusline.sh       → ~/.config/claude/statusline.sh
```

(Same symlinks exist under `~/.claude-personal/`.)

Each profile has its own `.claude.json` (runtime state: startup count, tips, theme, editorMode). This file is NOT shared — it contains per-profile state that gets regenerated.

User preferences that live in `.claude.json` (like `editorMode`) are enforced by `hooks/ensure-preferences.sh`, which runs on SessionStart. To change a preference, edit that hook script — don't edit `.claude.json` directly.
