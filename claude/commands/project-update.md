Update the Obsidian project file for the current workspace.

## Finding the project

1. From the current working directory, walk up the directory tree looking for `.workspace.json`.
2. Read `.workspace.json` and look for the `obsidian_project` field — this is the absolute path to the Obsidian project file.
3. If `.workspace.json` is not found, or has no `obsidian_project` field:
   - Ask the user which Obsidian project this workspace corresponds to.
   - List active projects from `~/Obsidian/Projects and Responsibilities/` to help them pick, or offer to create a new one.
   - Write the chosen path into `.workspace.json` (creating it if needed) so future invocations find it automatically.

## Updating the project

1. Read the Obsidian project file.

2. Ask the user what to update. Common updates:
   - Status change (active, on hold, completed)
   - Progress notes / what was accomplished
   - Add or check off TODOs/milestones
   - Update the `next-review` date
   - Add blockers or dependencies

3. Apply the updates to the Obsidian project file.

4. Show the user the updated file and confirm.

## Convention

`.workspace.json` in the workspace root:
```json
{
  "obsidian_project": "/Users/jeff/Obsidian/Projects and Responsibilities/Work/Projects/Active/ProjectName.md"
}
```

Obsidian project files should include this in frontmatter:
```yaml
workspace: /path/to/workspace/root
```

## Rules

- Don't modify code in the workspace — only update the Obsidian project file (and `.workspace.json` for initial setup).
- If the project file doesn't exist yet, offer to create one using the standard template (frontmatter with next-review, review-frequency, workspace path).
- Keep progress notes concise — this is a tracking file, not documentation.
