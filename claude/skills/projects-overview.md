---
name: projects-overview
description: Shows a bird's-eye view of all active projects — their status, goal alignment, and next action — split by Work and Personal. Read-only; does not create or modify anything.
---

# Instructions

You are running the projects-overview skill. Your job is to fetch all projects from Notion and present a structured, read-only summary. Do not create, update, or delete anything.

## Step 1: Fetch Active Projects

Query the Projects database (`5e1d336a-daeb-4daa-a6a8-8c9f22c15226`) using `notion-personal__notion-update-data-source` with a filter for Status = "Active". Do this once for Work projects and once for Personal projects, or fetch all Active projects and separate them by the Area/Type property afterward — use whatever filter structure the database supports.

If the database has a property that distinguishes Work vs. Personal (e.g. an "Area" or "Type" select), filter or group on it. If not, fetch all Active projects and split them visually based on that property's value.

## Step 2: For Each Project, Determine Goal Alignment

Each project page has a "Goal" relation field. For any project that has a Goal relation, fetch the linked goal name from the Goals database (`ffd1943c-0a71-439e-a38f-19c8828be29d`) using `notion-personal__notion-fetch` with the goal page ID. Cache goal names so you don't re-fetch the same goal twice.

## Step 3: For Each Project, Find the Next Incomplete Task

Query the Tasks database (`d790f3d1-0559-4917-a591-d77f96730806`) using `notion-personal__notion-update-data-source` with:
- Filter: Project relation = <project page ID> AND Status != "Done"
- Sort: by priority or creation date ascending (use whatever sort property is available)
- Limit: 1 result

The first result is the "next action" for that project. If no result, the next action is "No open tasks".

Do this for each Active project. You can batch these queries if the database supports it, but it is fine to run them sequentially.

## Step 4: Determine Status Flags

For each project, assign one or more status flags based on what you find:

- **Active** — has at least one open task
- **Stalled** — has no open tasks at all (next action = "No open tasks")
- **Blocked** — the project page has a "depends-on" relation or property pointing to another project that is still Active or On Hold
- **On Hold** — Status = "On Hold" (these should not appear if Step 1 filtered correctly, but flag if found)
- **New** — project was created within the last 7 days (check the "Created time" property)
- **No Goal** — the Goal relation field is empty

A project can carry multiple flags (e.g. Active + New, or Stalled + No Goal).

## Step 5: Present the Output

Present two tables — Work first, then Personal. Use this format:

```
## Work Projects

| Project | Status | Goal | Next Action |
|---------|--------|------|-------------|
| Project Name | Active | Goal Name | Short task description |
| Project Name | Stalled · No Goal | — | No open tasks |

## Personal Projects

| Project | Status | Goal | Next Action |
|---------|--------|------|-------------|
| Project Name | Active · New | Goal Name | Short task description |
```

Rules for the table:
- **Project**: Use the project's title. Do not include a link unless the user asks.
- **Status**: Combine flags with " · " (e.g. "Active · New", "Stalled · No Goal"). Use plain text, not emoji.
- **Goal**: The name of the linked goal, or "—" if none.
- **Next Action**: A short (one-line) description of the next open task. Trim to ~60 characters if long. If no tasks, write "No open tasks".

After both tables, show a one-line summary:

```
X active projects (Y work, Z personal). N stalled, N blocked, N with no goal.
```

Only count each project once in each category. Omit a category from the summary if the count is 0.

## What NOT to Do

- Do not show On Hold, Someday, or Completed projects.
- Do not create, update, or delete any Notion pages or records.
- Do not ask clarifying questions before running — just fetch and display.
- Do not show raw Notion IDs in the output.
- Do not reproduce full task text — keep Next Action short and scannable.
