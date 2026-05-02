---
name: goals-overview
description: Shows a bird's-eye view of all current goals — their status, which projects are serving each goal, and whether any active goal has no projects driving it. Read-only; does not create or modify anything.
---

# Instructions

You are running the goals-overview skill. Your job is to fetch all goals from Notion and present a structured, read-only summary grouped by status. Do not create, update, or delete anything.

## Step 1: Fetch All Goals

Query the Goals database (`ffd1943c-0a71-439e-a38f-19c8828be29d`) using `notion-personal__notion-update-data-source` with no filters (or a filter excluding Archived/Abandoned status if supported). Retrieve all goals. Note each goal's:
- Name
- Status (Active, On Hold, Achieved, or similar)
- Any description or notes field
- The list of related Project page IDs from the "Projects" relation field (if present)

## Step 2: Fetch Active and On-Hold Projects Per Goal

For each goal that has linked project IDs, fetch project details from the Projects database (`5e1d336a-daeb-4daa-a6a8-8c9f22c15226`). You can either:
- Use `notion-personal__notion-fetch` with each project page ID, or
- Query `notion-personal__notion-update-data-source` on the Projects DB filtered by Goal relation = <goal page ID>

For each project, note:
- Name
- Status (Active, On Hold, Someday, Completed, etc.)

Include only Active and On Hold projects in the output — skip Someday and Completed. If the Goal relation on the Projects side is the source of truth (rather than the Goals side), use that direction.

Cache project details to avoid re-fetching the same project for multiple goals.

## Step 3: Identify Coverage Gaps

For each Active goal:
- If it has zero Active projects serving it: mark it with a warning flag.
- If it has Active projects: it is covered.
- If it has only On Hold projects and no Active ones: note that as "projects paused".

## Step 4: Present the Output

Present goals in two sections: **Active Goals** first, then **On Hold Goals**. Use this format:

```
## Active Goals

| Goal | Active Projects | On Hold Projects | Notes |
|------|----------------|-----------------|-------|
| Goal Name | Project A, Project B | — | |
| Goal Name | — | — | ⚠️ No projects |
| Goal Name | Project C | Project D | |

## On Hold Goals

| Goal | Blocker / Reason | Projects |
|------|-----------------|----------|
| Goal Name | Blocked by: Condo purchase | — |
| Goal Name | — | Project E |
```

Rules for the output:
- **Goal**: Use the goal's title. No raw Notion IDs.
- **Active Projects**: Comma-separated list of Active project names serving this goal, or "—" if none.
- **On Hold Projects**: Comma-separated list of On Hold project names serving this goal, or "—" if none.
- **Notes**: Use "⚠️ No projects" if an Active goal has no Active projects at all. Leave blank otherwise.
- **On Hold Goals — Blocker / Reason**: Include any blocker note from the goal's description or a "blocked by" field. If none, use "—".
- Keep project names short — trim to ~50 characters if long.

After both sections, show a brief summary line:

```
X active goals (Y covered, Z with no active projects). N goals on hold.
```

Omit a category from the summary if the count is 0.

## What NOT to Do

- Do not show Achieved or Archived goals unless the user explicitly asks.
- Do not create, update, or delete any Notion pages or records.
- Do not ask clarifying questions before running — just fetch and display.
- Do not show raw Notion IDs in the output.
- Do not reproduce full project task lists — this is a goal-level overview only.
