#!/bin/bash
# PreToolUse hook guarding AWS/Kubernetes credentials & config.
#
# Blocks:
#   - Bash commands that set/export/unset AWS_PROFILE or KUBECONFIG
#   - Bash commands that directly reference files under ~/.aws or ~/.kube
#     (cat, cp, sed, redirects, etc.)
#   - Write/Edit of files under ~/.aws or ~/.kube, and writing scripts whose
#     content references those paths
#
# Deliberately allowed: CLI tools (aws, kubectl, helm, ...) that read those
# folders internally without the path appearing in the command.

input=$(cat)
tool=$(echo "$input" | jq -r '.tool_name // ""')

VARS='(AWS_PROFILE|KUBECONFIG)'
# ~/.aws, $HOME/.aws, ${HOME}/.aws, /Users/x/.aws, /home/x/.aws, bare .aws/
PATHS='((~|\$HOME|\$\{HOME\}|/Users/[^/[:space:]]+|/home/[^/[:space:]]+)/\.(aws|kube)([/[:space:]"'"'"';&|)]|$)|(^|[[:space:]"'"'"'=(])\.(aws|kube)/)'

deny() {
  cat <<EOF
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked: $1"}}
EOF
  exit 0
}

ENV_REASON="Claude Code must never set, override, or unset AWS_PROFILE or KUBECONFIG. Use the values already present in the environment. If a different profile/cluster is needed, ask the user to switch it themselves."
PATH_REASON="Claude Code must never directly read from or modify ~/.aws or ~/.kube (including via scripts it writes). Use CLI tools like aws/kubectl, which read these folders internally, instead."

if [ "$tool" = "Bash" ]; then
  cmd=$(echo "$input" | jq -r '.tool_input.command // ""')
  if echo "$cmd" | grep -qE "${VARS}=" ||
     echo "$cmd" | grep -qE "(^|[;&|[:space:]\`\$(])(export|unset|setenv|declare|typeset)[[:space:]][^;&|]*${VARS}" ||
     echo "$cmd" | grep -qE "(^|[;&|[:space:]\`\$(])set[[:space:]]+(-[A-Za-z]+[[:space:]]+)*${VARS}([[:space:]]|\$)"; then
    deny "$ENV_REASON"
  fi
  if echo "$cmd" | grep -qE "$PATHS"; then
    deny "$PATH_REASON"
  fi
else
  # Write / Edit / NotebookEdit
  target=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // ""')
  case "$target" in
    "$HOME"/.aws/*|"$HOME"/.kube/*|"$HOME"/.aws|"$HOME"/.kube)
      deny "$PATH_REASON" ;;
  esac
  # Claude Code's own config (settings, hooks, CLAUDE.md) legitimately
  # mentions these paths — e.g. the deny rules that implement this guard.
  # Skip the content scan there; the file-path check above still applies.
  case "$target" in
    "$HOME"/.config/claude/*|"$HOME"/.claude/*|"$HOME"/.claude-personal/*)
      exit 0 ;;
  esac
  content=$(echo "$input" | jq -r '(.tool_input.content // "") + "\n" + (.tool_input.new_string // "") + "\n" + (.tool_input.new_source // "")')
  if echo "$content" | grep -qE "$PATHS"; then
    deny "$PATH_REASON"
  fi
fi

exit 0
