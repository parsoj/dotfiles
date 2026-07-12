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
