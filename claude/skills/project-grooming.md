---
name: project-grooming
description: Interactively groom all active projects one at a time — reviewing tasks, clarifying next actions, updating status, and moving projects between Active, On Hold, Someday, and Completed. Always shows current tasks before asking any questions.
---

# Instructions

You are running an interactive project grooming session using the `notion-personal` MCP server. Work through active projects one at a time, helping Jeff review and update them. Never ask Jeff to recall a project's state from memory — always fetch and display current data first.

## Database IDs

- Goals DB: `ffd1943c-0a71-439e-a38f-19c8828be29d`
- Projects DB: `5e1d336a-daeb-4daa-a6a8-8c9f22c15226`
- Tasks DB: `d790f3d1-0559-4917-a591-d77f96730806`

## Step 1 — Load and display all active projects

Query the Projects DB for all Active projects:

```
notion-personal__notion-update-data-source
  database_id: "5e1d336a-daeb-4daa-a6a8-8c9f22c15226"
  filter: { property: "Status", select: { equals: "Active" } }
  sorts: [{ property: "Area", direction: "ascending" }]
```

Display the full list grouped by Area (Work first, then Personal). Show each project's name, area, goal (if any), and next-review date. This is the starting overview.

## Step 2 — Prune: bulk status changes before deep review

Show the numbered list of active projects and ask Jeff which ones should be moved before you start the detailed review:

```
1. Project A (Work)
2. Project B (Personal)
...

Actions: keep · hold · someday · done · cancel
Unlisted = keep. Example: "1 hold, 3 cancel"
```

For each project Jeff wants to move, call:

```
notion-personal__notion-update-page
  page_id: <project_page_id>
  properties: { "Status": { "select": { "name": "<On Hold | Someday | Completed | Cancelled>" } } }
```

After applying all moves, re-display the updated Active list so Jeff can see what remains for deep review.

## Step 3 — Deep review: one project at a time

Work through each remaining active project one at a time. **Work projects first, then Personal.**

For each project, do the following in order — no skipping:

### 3a. Fetch project details

```
notion-personal__notion-fetch
  id: <project_page_id>
```

### 3b. Fetch open tasks for this project

```
notion-personal__notion-update-data-source
  database_id: "d790f3d1-0559-4917-a591-d77f96730806"
  filter: {
    and: [
      { property: "Project", relation: { contains: "<project_page_id>" } },
      { property: "Status", status: { does_not_equal: "Done" } }
    ]
  }
  sorts: [{ property: "Status", direction: "ascending" }]
```

### 3c. Display current state — ALWAYS before asking anything

Show:
- **Project name** and Area
- **Goal** it serves (if linked)
- **Status flags** derived from the data: stalled (no recent activity), blocked (has a dependency that isn't done), deadline (due date is near)
- **Open tasks** — list every task with its name and status. If there are no open tasks, say so explicitly.
- **Last reviewed** date if available

Only after displaying all of this, ask:

> "Does this look right? Anything to add, remove, or reword in the tasks? Should the project status change?"

### 3d. Handle flags

Address any status flags before moving on:

- **Stalled** (no open tasks or no recent progress): Does it need new tasks added, or should it be shelved (On Hold / Someday)?
- **Blocked** (depends on an incomplete project): Is the blocker resolved? If still blocked, move to On Hold.
- **Deadline** (due date within 2 weeks): Is there prep scheduled for this week?

### 3e. Apply updates

Based on Jeff's response:

- **Add a task**: `notion-personal__notion-create-pages` — create a new page in the Tasks DB with the Project relation set to this project's ID and Status set to "Not started".
- **Update a task** (rewording, status change): `notion-personal__notion-update-page` on the task page.
- **Remove/cancel a task**: `notion-personal__notion-update-page` — set Status to "Cancelled" (do not delete).
- **Change project status**: `notion-personal__notion-update-page` on the project page — update the Status select property.
- **Update next-review date**: `notion-personal__notion-update-page` on the project page — set the next-review date property to today + 7 days.

Apply changes immediately after Jeff confirms them. Do not batch changes across projects.

After finishing one project, confirm you're moving on and load the next one.

## Step 4 — Confirm next actions

After all projects are reviewed, verify that every remaining active project has at least one open task that is not blocked. If any project has no open tasks, flag it and ask Jeff whether to add one or move the project to On Hold.

Then display a final overview of all active projects with their task counts, using the same Projects DB query from Step 1.

## Step 5 — Bump review dates

For all projects reviewed in this session where you haven't already updated next-review, set next-review to today's date + 7 days via `notion-personal__notion-update-page`.

## Rules

- **ALWAYS show the current task list before asking any question about a project.** Never ask "anything to change?" without first displaying what's there.
- Show the overview after Step 2 (pruning) and after Step 4 (final state).
- Go through projects one at a time — do not batch the deep review.
- Apply updates immediately — do not accumulate changes and apply them at the end.
- Work projects before Personal projects in Step 3.
- Never ask Jeff to recall tasks, status, or dates from memory.
