Show the Obsidian project status for the current workspace.

## Finding the project

1. From the current working directory, walk up the directory tree looking for `.workspace.json`.
2. Read `.workspace.json` and look for the `obsidian_project` field.
3. If not found, tell the user and suggest running `/project-update` to set one up.

## Displaying status

1. Read the Obsidian project file.

2. Display a summary:
   - Project name and status (active/on hold)
   - Next review date and whether it's overdue
   - Open TODOs / milestones
   - Recent progress notes (last few log entries)
   - Goal(s) this project serves (if linked)

3. Optionally, check git log in the current workspace for recent activity and note if there's been work that isn't reflected in the project file.

## Rules

- Read-only — don't modify anything. Use `/project-update` for changes.
- Keep output concise and scannable.
