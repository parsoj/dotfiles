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
