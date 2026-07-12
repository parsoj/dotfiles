#!/bin/bash
# On every prompt submit, record this session's id keyed by cwd. The /branch
# skill reads this to learn the invoking session's id (CLAUDE_SESSION_ID is
# not exposed to Bash tool subprocesses). Invoking /branch fires this hook,
# so the snapshot is always fresh for the session that asked.
set -euo pipefail

input=$(cat)
session_id=$(jq -r '.session_id // ""' <<<"$input")
cwd=$(jq -r '.cwd // ""' <<<"$input")
[ -n "$session_id" ] && [ -n "$cwd" ] || exit 0

dir="$HOME/.claude/run/session-by-cwd"
mkdir -p "$dir"
key=$(md5 -q -s "$cwd" 2>/dev/null || md5sum <<<"$cwd" | cut -d' ' -f1)
jq -n --arg sid "$session_id" --arg cwd "$cwd" --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{session_id: $sid, cwd: $cwd, ts: $ts}' > "$dir/$key.json"
exit 0
