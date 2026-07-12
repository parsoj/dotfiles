# Workspace Shell-Repo Redesign

Status: **design settled 2026-07-12, not built.** Designed via /dp discussion; empirical
claims below were verified by experiment, not assumed.

## Goal

An elaborate `/branch` for Claude Code: one verb that forks the **claude session**, the
**whole multi-repo workspace** (worktrees + dirty state), and opens a **new cmux
workspace** running the forked session — leaving the original session and checkout
untouched.

## Core idea

Claude Code sessions are stored per-cwd, but session lookup for `--resume` spans a repo
**and its git worktrees**. So: make every workspace root a worktree of one shared shell
repo, and session forking across workspaces becomes native.

- One shell repo: `~/code/repos/workspace-home`.
- Every workspace root in `~/code/workspaces/<name>` is a worktree of it, on branch
  `<name>` (extends the existing branch-per-workspace convention to the root).
- Child repos stay exactly what they are today: worktrees of `~/code/repos/*`, one shared
  clone per repo.
- Forking a session into a new workspace is then just, from the new root:
  `claude --resume <session-id> --fork-session`

### Verified by experiment (2026-07-12)

- A session created in worktree A resumes **and forks** from sibling worktree B; full
  context carries; fork reports the new cwd. (Tested headless `-p`; interactive uses the
  same lookup path — confirm on first real use.)
- The fork's transcript lands in the **new** root's project slug → future resumes from
  the new workspace work natively. Original session file untouched.
- Child repos must be **untracked, NOT gitignored** in workspace-home: gitignoring them
  makes `rg` (and therefore Claude's Grep tool) silently blind to all code when run from
  the workspace root. Untracked-not-ignored: `rg` sees everything; `git status` cost is
  one `?? <repo>/` line each.
- `git clean -fd` at the root refuses to touch nested repos (worktree `.git`-file case
  included); it takes `-ffd` to destroy them.

## Manifest

`.workspace.json` is promoted from marker to **tracked manifest**: which repos, which
branches, plus metadata. Schema is **additive** — existing fields (`obsidian_project`,
used by /project-status et al.) are preserved. All marker-walking code keeps working.

Follow-up (requested 2026-07-12): `created` timestamp, and a "last worked on" field —
possibly derived (child reflog dates / mtimes) rather than stored; decide at build time.

## New verbs

- **`workspace_sync`** — read manifest, materialize missing child worktrees (subsumes the
  guts of `repo_add`; also handles `.worktree-setup` symlinks). Installed as a
  `post-checkout` hook in workspace-home so that **any** tool doing `git worktree add` on
  the shell repo (Claude worktree isolation, cmux, bare git) yields a populated workspace.
- **`workspace_fork <name>`** — root worktree off the source root's branch → sync →
  per child repo: worktree on branch `<name>` based at the source worktree's HEAD, dirty
  state duplicated (diff-apply + untracked copy), `gt track` where source was tracked.
- **`/branch <name>`** (claude skill) — `workspace_fork`, then `cmux new-workspace --cwd
  <new-root>` launching `claude --resume <session-id> --fork-session` (env scrubbed of
  `CLAUDE_CODE_CHILD_SESSION` — see cmux-dev.fish for why), first prompt = relocation
  note ("you were forked; you now live in <path> on branch <name>").

## Rejected alternatives

- **Submodules**: pin commits not branches (workflow is live branches + dirty state),
  janky with worktrees (`worktree add` doesn't materialize them), lose shared object
  stores. The declarative benefit is captured by the manifest instead.
- **fork-then-`/cd`**: works (`/cd` officially relocates a live session, v2.1.169+) but
  needs keystroke injection to automate. Kept as the fallback if worktree-scoped lookup
  ever changes.
- **Transcript `.jsonl` copy**: works, unsupported, may break on any release. Last resort.

## Change list (bounded)

| Item | Work |
|---|---|
| `workspace_create` | rewrite: `worktree add -b <name>` instead of mkdir; seed manifest |
| `workspace_clean` | rewrite: `worktree remove` per child + root, `branch -D` root, prune. Fixes a **pre-existing bug**: today's `rm -rf` leaves stale registrations in every child repo (why `repo_add` has the prune prompt) |
| `workspace_rename` | extend: root gitdir-pointer surgery (or `worktree move`) + `git branch -m` root branch. Child branches keep old names (matches today) |
| `repo_add` | record repo in manifest; mechanics unchanged |
| `repo_list` | exclude workspace-home |
| `workspace_sync`, `workspace_fork`, `/branch` skill | new |
| Migration | one-time: adopt each existing root as a worktree, seed manifests; plus `git worktree prune` sweep across `~/code/repos/*` |

Everything else — all pickers/flows (`gw`, `wat`, spinout, kitty/tmux/zellij/doom/starship
integration) — is marker- or path-based and rides through unchanged. (Verified by sweep
of the whole config repo.)

## Hardening

- `pre-commit` hook in workspace-home: reject gitlink entries (a root-level `git add .`
  would otherwise stage child repos as submodule pointers).
- Optionally block `git clean -ff` in `claude/hooks/protect-code-repos.sh`.
- Shared workspace CLAUDE.md, if wanted, should be a **symlink** into `~/.config`, not
  tracked content (tracked content only reaches new branches at creation time).

## Accepted behavior changes

- `--resume` session pool spans all workspaces (the point; picker may get noisy).
- Starship shows branch `<name>` at workspace roots; projectile/doom see roots as
  projects; `rprt` at a root lands on the root instead of erroring.
- Repo-identity features (teleport, web session association) see "workspace-home" from
  root sessions — none worked from roots before, so no regression.

## Verify at build time

1. Does the interactive `--resume` picker span sibling worktrees? (noise check only)
2. Is `CLAUDE_SESSION_ID` present in the Bash tool env? (else: SessionStart hook records it)
3. Does `cmux new-workspace` accept an initial command? (else: add it — Jeff owns cmux)
4. Interactive fork-from-sibling-worktree behaves like the verified headless case.

## Build order

1. Bootstrap workspace-home + rewrite `create`/`clean` + migration (standalone value).
2. Manifest schema + `workspace_sync` + post-checkout hook.
3. `workspace_fork` + `/branch` skill + cmux launch integration.
