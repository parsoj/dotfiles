#!/usr/bin/env bash
# PreToolUse guard: in Graphite-managed repos, block raw GitHub PR creation
# and pushes of Graphite-untracked branches — branch/PR management must go
# through gt (gt create / gt modify / gt submit / gt track).
# Fast-exits for anything else. Fails open on unexpected errors.
set -uo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[ -z "$cmd" ] && exit 0

# Cheap prefilter before any git invocation.
case "$cmd" in
  *"gh pr create"*|*"gh pr edit"*|*git*) ;;
  *) exit 0 ;;
esac

deny() {
  jq -cn --arg reason "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
  exit 0
}

# Only enforce inside Graphite-initialized repos.
common_dir=$(git rev-parse --git-common-dir 2>/dev/null) || exit 0
[ -f "$common_dir/.graphite_repo_config" ] || exit 0

case "$cmd" in
  *"gh pr create"*)
    deny "This repo is Graphite-managed: create PRs with 'gt submit --stack --no-interactive' (branch via 'gt create <name> -am \"msg\"'), not 'gh pr create'. See the Graphite section in ~/.claude/CLAUDE.md."
    ;;
  *"gh pr edit"*--base*)
    deny "This repo is Graphite-managed: don't re-base PRs with 'gh pr edit --base' — restack with 'gt move'/'gt restack' and 'gt submit'."
    ;;
esac

# In Graphite repos, ALL git invocations go through gt (decision 2026-07-27:
# one mental model). gt passes unrecognized commands through to git verbatim,
# so reads cost nothing: gt status, gt diff, gt log, gt rev-parse ...
# Matches git in command position (start, after ;|&|(, or $( ).
if printf '%s' "$cmd" | grep -qE '(^|[;&|(]|\$\()[[:space:]]*git[[:space:]]'; then
  deny "This repo is Graphite-managed: use gt for ALL git operations — it passes unknown commands through to git verbatim (gt status, gt diff, gt log, gt rev-parse, ...). Branch/commit/PR management: gt create / gt modify / gt restack / gt submit."
fi

# (Belt-and-braces below in case a git push slips past the pattern above.)
# git push: allow only if every branch being pushed is Graphite-tracked
# (present in gt's sqlite metadata DB). Deletions (":ref") are allowed.
tracked() {
  local n
  n=$(sqlite3 "$common_dir/.graphite_metadata.db" \
    "select count(*) from branch_metadata where branch_name='${1//\'/\'\'}'" 2>/dev/null) || return 0
  [ "${n:-0}" -gt 0 ]
}
if printf '%s' "$cmd" | grep -q "git push"; then
  # Collect candidate branch names: refspec args after the remote, else HEAD.
  branches=$(printf '%s' "$cmd" | tr ';|&' '\n' | grep "git push" | head -1 |
    awk '{for(i=3;i<=NF;i++) if ($i !~ /^-/ && $i != "origin" && $i !~ /^:/) print $i}')
  if [ -z "$branches" ]; then
    branches=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
  fi
  for b in $branches; do
    b="${b%%:*}"                      # local side of a refspec
    b="${b#refs/heads/}"
    [ -z "$b" ] && continue
    case "$b" in main|master|HEAD) continue ;; esac
    if ! tracked "$b"; then
      deny "Branch '$b' is not Graphite-tracked — pushing it raw creates a GitHub-only branch invisible to gt/gs. Use 'gt create'/'gt submit', or adopt it first: gt track --parent <parent> -f (then gt submit)."
    fi
  done
fi

exit 0
