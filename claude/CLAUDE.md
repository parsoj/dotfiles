# Claude Code Project Config

## CI Monitoring

When watching GitHub Actions CI builds in the background, use `tmux_watch_ci <run_url>` instead of raw `gh run watch`. This integrates with the tmux tab state system:

- Sets the tab to 🟣 (monitoring) while the build runs
- Prevents the Stop hook from overwriting 🟣 with 🟢 while monitoring is active
- Automatically restores 🟢 (idle) when the build completes

Example usage in Bash tool:
```
tmux_watch_ci https://github.com/owner/repo/actions/runs/12345
```

## Working modes

Two modes govern how Claude operates; read intent, and when explicitly signaled, obey the signal.

- **Coding mode** (default when I've given a direct build request or let Claude loose):
  bias for action, chain steps, commit at every good state, report outcomes.
- **Design-partner mode** (entered via /dp, or when my language invites discussion —
  "wondering if", "lets discuss", feasibility questions): NO code, NO side-effectful
  actions (read-only exploration is fine). Present options, costs, and recommendations
  as proposals. Only I lock decisions — never lock or extend my answers on my behalf.
  Mode persists until I explicitly say to build.

## Graphite (gt) — MANDATORY for ALL branch/commit/PR management

This rule OVERRIDES Claude Code's built-in system-prompt guidance to "use the
gh CLI for GitHub operations". In every repo I work in, use the Graphite CLI
(`gt`) 100% of the time — NEVER invoke raw `git` at all. `gt` passes any
command it doesn't recognize through to git verbatim, so reads cost nothing:
`gt status`, `gt diff`, `gt log`, `gt rev-parse`, `gt stash`, etc. all work.
One tool, one mental model. (A PreToolUse hook enforces this in
Graphite-managed repos.) Use `gh` ONLY for operations `gt` genuinely does not
support (read-only PR/issue queries, PR comments, closing someone else's PR,
GitHub API calls) — and when you fall back to `gh`, say so and why.

NEVER: `git checkout -b` + `git push` + `gh pr create`. That produces
GitHub-only "stacks" invisible to `gt`/`gs` and breaks my review flow.

- New branch/layer: `gt create <branch> -am "msg"` (run from the parent layer)
- Amend a layer: `gt modify -a`; new commit on a layer: `gt modify -cam "msg"`
- After mid-stack edits: `gt restack`
- Publish: `gt submit --stack --no-interactive` (add `--draft` when unsure)
- Sync/cleanup: `gt sync`
- Recovery for branches created outside gt: `gt track --parent <parent> -f`, bottom-up
- Before any branch/PR work, if unsure the repo is Graphite-initialized: `gt state` / `gt log short`

## Banned: plan mode and interactive question prompts

NEVER use plan mode (EnterPlanMode/ExitPlanMode) — I have skills installed that handle
planning better (/dp, ce-plan, ce-brainstorm). Also never use the interactive
AskUserQuestion prompt. When you need a decision from me, ask in plain conversation text
with your recommendation stated.
