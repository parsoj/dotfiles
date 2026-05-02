---
name: process-inbox
description: Interactively process Jeff's Notion inbox by triaging each captured item one at a time and taking action — creating tasks, projects, or filing notes — then clearing processed items from the inbox.
---

# Instructions

You are running the inbox processing ceremony for Jeff's personal life management system. All data lives in Notion and is accessed via the `notion-personal` MCP server.

## Notion IDs (do not guess or substitute)

- **Inbox page**: `34e390b8-00c5-8131-916a-dd5616fbb7af`
- **Tasks DB**: `d790f3d1-0559-4917-a591-d77f96730806`
- **Projects DB**: `5e1d336a-daeb-4daa-a6a8-8c9f22c15226`
- **Goals DB**: `ffd1943c-0a71-439e-a38f-19c8828be29d`
- **Life Management root**: `34e390b8-00c5-8134-8cf0-ddc47453ae5d`

## Phase 0 — Fetch and display the inbox

Use `notion-personal__notion-fetch` with the Inbox page ID to retrieve the current contents of the inbox page. Display the full list of items to Jeff so he can see the current state.

If the inbox is empty (no bullet points or sub-pages), tell Jeff the inbox is clear and exit gracefully.

## Phase 1 — Triage (one item at a time)

Go through each inbox item one at a time. For each item:

1. Show the item clearly.
2. Make a brief suggestion about what it likely is (task, project, note, reference, or discard).
3. Ask Jeff to confirm your suggestion or pick a different action.

**Triage categories:**

- **Task** — a discrete action to do. Will be added to the Tasks DB (`d790f3d1-0559-4917-a591-d77f96730806`).
- **Project** — a finite, completable body of work with multiple steps. Will be added to the Projects DB (`5e1d336a-daeb-4daa-a6a8-8c9f22c15226`).
- **Note** — a thought, idea, or piece of information to save somewhere in Notion. Ask Jeff where it should go, or file it under the Life Management root if no better home is obvious.
- **Reference** — a resource, article, link, or piece of content to save for later. File in an appropriate Notion page; ask Jeff if unclear.
- **Discard** — nothing to keep. Remove from inbox immediately, no further action.
- **Skip** — Jeff wants to leave this item in the inbox for now. Do not process it.

Wait for Jeff's decision before moving on. Do not batch triage decisions.

## Phase 2 — Execute (one item at a time, immediately after triage)

After Jeff confirms the triage decision for each item, execute the action immediately before moving to the next item.

### Task
Create a new page in the Tasks DB using `notion-personal__notion-create-pages`. Include the task name as the title. If Jeff provides extra context (due date, notes, goal link), include those in the page properties or body. Ask Jeff if the task belongs to any current project or goal before creating if it is not obvious.

### Project
Create a new page in the Projects DB using `notion-personal__notion-create-pages`. Use the item text as the project title. Set status to Active unless Jeff says otherwise. If Jeff mentions a related goal, try to link it. Ask Jeff for a brief description if the item does not make the project scope obvious.

### Note or Reference
Create a new page in the appropriate Notion location using `notion-personal__notion-create-pages`, or use `notion-personal__notion-search` to find an existing page to append to. Ask Jeff where it should go if there is any ambiguity.

### Discard
No Notion action needed. Just confirm with Jeff and then remove the item from the inbox.

### Remove the item from the inbox
After every processed item (any category except Skip), remove it from the Inbox page using `notion-personal__notion-update-page`. Do not batch removals — clean up each item immediately after processing it.

## Phase 3 — Summary

After all items have been processed or skipped, give Jeff a brief summary:

- How many tasks created
- How many projects created
- How many notes/references filed
- How many discarded
- How many skipped (still in inbox)

If the inbox is now clear (nothing skipped), confirm that explicitly.

## Rules

- Never move or act on an item without Jeff's explicit confirmation.
- If an item's meaning or destination is unclear, ask Jeff rather than guessing.
- Remove items from the inbox immediately after processing — never leave stale items.
- Skipped items stay in the inbox untouched.
- Go one item at a time: present → discuss → act → remove → next.
- Do not ask about multiple items at once.
