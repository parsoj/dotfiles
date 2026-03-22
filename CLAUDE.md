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
