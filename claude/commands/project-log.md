Append a quick progress entry to the Obsidian project file for the current workspace.

This is a fast, low-friction way to log what you just did without going through the full `/project-update` flow.

## Finding the project

1. From the current working directory, walk up the directory tree looking for `.workspace.json`.
2. Read `.workspace.json` and look for the `obsidian_project` field.
3. If not found, tell the user and suggest `/project-update` to set one up.

## Logging

1. Read the Obsidian project file.

2. Take the user's input (either from the argument passed to this command, or ask them).

3. Append a timestamped entry to a `## Log` section in the project file:
   ```
   - **2026-03-21:** <user's note>
   ```
   Create the `## Log` section at the bottom if it doesn't exist yet.

4. Confirm the entry was added.

## Rules

- Minimal interaction — this should be fast.
- Don't modify anything else in the project file.
- If the user passes an argument (e.g. `/project-log shipped the API endpoint`), use that directly without prompting.
