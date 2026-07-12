#!/bin/bash
# Blocks Claude tool calls that touch ~/code/repos — the canonical repo clones
# that back worktrees. Policy: interact with repos ONLY via worktrees created
# by `repo_add` in a workspace. The sole allowed direct interactions are
# listing the repos and checking a repo's remotes to confirm its identity.
set -euo pipefail

input=$(cat)
tool=$(jq -r '.tool_name // ""' <<<"$input")

deny() {
  jq -n --arg r "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $r
    }
  }'
  exit 0
}

REASON="~/code/repos hosts canonical clones only. Never interact with it directly: use repo_add (fish function) in the current workspace to create a worktree, or repo_add <github-url> to clone a new repo. Allowed exceptions: plain ls of ~/code/repos and git -C <repo> remote -v."

# Matches ~/code/repos, $HOME/code/repos, /Users/jeff/code/repos
PATH_RE='(~|\$HOME|/Users/jeff)/code/repos'

case "$tool" in
  Bash)
    cmd=$(jq -r '.tool_input.command // ""' <<<"$input")
    if grep -qE "$PATH_RE" <<<"$cmd"; then
      # Allowed: a single plain `ls` of the repos dir (no pipes/chains)
      if grep -qE "^ls( -[A-Za-z1]+)* ($PATH_RE/?|$PATH_RE/[A-Za-z0-9._-]+/?)$" <<<"$cmd"; then
        exit 0
      fi
      # Allowed: remote check to confirm a repo's identity (no pipes/chains)
      if grep -qE "^git -C \"?$PATH_RE/[A-Za-z0-9._-]+\"?/? remote( -v)?$" <<<"$cmd"; then
        exit 0
      fi
      deny "$REASON"
    fi
    ;;
  Read|Grep|Glob|Edit|Write|NotebookEdit)
    # Check only target-path fields; scanning full tool_input would also block
    # edits to unrelated files whose CONTENT mentions the protected path.
    targets=$(jq -r '[.tool_input.file_path?, .tool_input.path?, .tool_input.notebook_path?] | map(select(. != null)) | join("\n")' <<<"$input")
    if [ -n "$targets" ] && grep -qE "$PATH_RE" <<<"$targets"; then
      deny "$REASON"
    fi
    ;;
esac

exit 0
