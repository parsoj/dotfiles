---
name: branch
description: Fork this claude session AND the current workspace into a new cmux workspace — new worktrees of every repo, dirty state duplicated, conversation context carried over via --fork-session. Use when jeff invokes /branch <name>, or asks to "branch this session/workspace", "fork this workspace", or "spin this conversation into a new workspace". Requires being inside a workspace (a directory under ~/code/workspaces).
---

# /branch — fork session + workspace + cmux workspace

Forks three things at once, leaving the original completely untouched:
1. the **workspace** (new root worktree of workspace-home; child repos branched
   off the source worktrees' HEADs; uncommitted changes duplicated),
2. this **claude session** (`--fork-session` from the new root — session lookup
   spans workspace-home worktrees, so full conversation context carries),
3. a **cmux workspace** opened on the new root running the forked session.

Design: ~/.config/docs/workspace-shell-repo-design.md

## Steps

1. **Name.** Use the argument as the new workspace name. If none given, ask.

2. **Preconditions.** Confirm the cwd is inside a workspace
   (`fish -c workspace_root` succeeds). If not, tell jeff and stop.

3. **Session id.** Read it from the snapshot the UserPromptSubmit hook keeps:

   ```bash
   key=$(md5 -q -s "$PWD"); jq -r .session_id ~/.claude/run/session-by-cwd/$key.json
   ```

   Use the session's original cwd for `$PWD` (the directory claude was started
   in — if you've cd'd around in this shell, use the session cwd, not the shell
   cwd). If the file is missing, fall back to the most recently modified
   `*.jsonl` in `~/.claude/projects/<slug-of-cwd>/` and use its basename.

4. **Fork the workspace.**

   ```bash
   fish -c 'cd <session-cwd> && workspace_fork <name>'
   ```

   Relay its output (dirty-state copy results, warnings) to jeff.

5. **Open the cmux workspace running the forked session.** The env scrub
   matters: `CLAUDE_CODE_CHILD_SESSION` leaking into the new pane silently
   disables transcripts/--resume (see cmux-dev.fish).

   ```bash
   cmux new-workspace --name "<name>" --cwd ~/code/workspaces/<name> --focus true \
     --command "env -u CLAUDE_CODE_CHILD_SESSION -u CLAUDECODE claude --resume <session-id> --fork-session '<relocation note>'"
   ```

   Relocation note (single line, adjust paths/branch): *"This session was
   forked with /branch. You now live in ~/code/workspaces/<name> (branch
   <branch>), a fork of <old-workspace> — same repos as worktrees on new
   branches, dirty state duplicated. The original session continues
   separately; re-verify paths before acting on earlier file references."*

6. **Report.** Tell jeff the new workspace path, its branch, and that the
   forked session is starting in the new cmux workspace. If `workspace_fork`
   warned about a Tennr child, remind: `gt track` in the fork's Tennr.

## Failure modes

- `workspace_fork` fails (name collision, unadopted root): report its stderr;
  don't create the cmux workspace.
- cmux CLI unavailable (not running / headless): give jeff the exact `claude
  --resume <id> --fork-session` command to run manually from the new root.
- Session id not found: ask jeff to send any message and re-invoke /branch
  (the hook snapshots on every prompt), rather than guessing an id.
