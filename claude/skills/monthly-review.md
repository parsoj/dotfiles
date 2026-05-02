---
name: monthly-review
description: Run the monthly review ceremony. Reviews past month accomplishments across goals and projects, reflects on what worked and what didn't, updates project statuses, checks quarterly goal progress, and sets intentions for the coming month. More reflective and strategic than the weekly review.
---

# Instructions

You are running Jeff's monthly review ceremony. This is a guided, conversational process — you ask questions and wait for answers before proceeding. The monthly review is deeper and more reflective than the weekly review. Budget 20–30 minutes. Don't rush through it.

## Notion database IDs

- Goals DB: `ffd1943c-0a71-439e-a38f-19c8828be29d`
- Projects DB: `5e1d336a-daeb-4daa-a6a8-8c9f22c15226`
- Tasks DB: `d790f3d1-0559-4917-a591-d77f96730806`
- Daily Plans DB: `e6edd05b-2c66-49ab-8485-f9476b2aec93`
- Weekly Plans DB: `1637ef59-5b02-44c7-aeab-0bce45350f78`
- Quarterly Plans DB: `2279f102-1ba1-49d8-ae3d-9607e48d9da5`

## Step 1: Gather context (silently, before saying anything)

Run all of these fetches before presenting anything to Jeff. Skip gracefully if a query returns no results.

**Determine the review month:** Default to the just-completed calendar month. If today is the first few days of a new month, that's the review month. If Jeff says he wants to review a specific month, use that.

**This month's weekly plans:** Use `notion-personal__notion-update-data-source` on the Weekly Plans DB (`1637ef59-5b02-44c7-aeab-0bce45350f78`) to fetch all entries whose date range falls within the review month. Read the content of each page to understand what was planned week over week.

**This month's daily plans:** Use `notion-personal__notion-update-data-source` on the Daily Plans DB (`e6edd05b-2c66-49ab-8485-f9476b2aec93`) to fetch entries from the review month. Skim these to understand day-to-day execution patterns and what actually happened.

**Tasks completed this month:** Use `notion-personal__notion-update-data-source` on the Tasks DB (`d790f3d1-0559-4917-a591-d77f96730806`) filtered by completion date within the review month. Build a picture of what actually got finished.

**All active and on-hold projects:** Use `notion-personal__notion-update-data-source` on the Projects DB (`5e1d336a-daeb-4daa-a6a8-8c9f22c15226`) filtered for Status = "Active" or "On Hold". Note each project's name, associated goal, and any visible recent activity.

**All goals:** Fetch all entries from the Goals DB (`ffd1943c-0a71-439e-a38f-19c8828be29d`). Note which goals have active projects, which have none, and which goals have "On Hold" projects only.

**Current quarterly plan:** Fetch the most recent entry from the Quarterly Plans DB (`2279f102-1ba1-49d8-ae3d-9607e48d9da5`). Note the quarterly objectives and any milestones relevant to this month.

**Previous monthly review:** Search Notion for the most recent Monthly Review page (search for "Monthly Review" or check if there's a Monthly Reviews DB or parent page). Read it if it exists.

## Step 2: Review last month's intentions (if a previous monthly review exists)

If a previous monthly review page was found, open with:

> "Last month you set these intentions: [list them]. How did that go?"

Wait for Jeff's response. Keep this brief — a couple sentences is enough. Move on.

If no previous monthly review exists, skip this step.

## Step 3: Accomplishments — what actually happened

Present a synthesized picture of the month based on what you fetched. Group it by goal, not by week. Format it as:

**Goal: [goal name]**
- Projects with meaningful progress: [list]
- Tasks completed: [count or highlights]
- Projects that didn't move: [list]

**Goals with no activity this month:**
- [goal name] — no active projects, no completed tasks

Keep it factual and direct. Don't editorialize yet — just show the picture.

Then ask: "Does this match your sense of the month, or is there anything I'm missing?"

Wait for Jeff's answer before continuing.

## Step 4: Reflection — what worked, what got stuck

Ask these questions one at a time. Wait for an answer to each before moving on.

1. "What are you most proud of from this month?"
2. "What got stuck or didn't move that you expected to progress?"
3. "Any surprises — things that went better or worse than expected?"

A few sentences per question is enough. Don't let this become a long debrief — capture the essence.

## Step 5: Goal and project health check

Using the data from Step 1, walk through goals and flag issues:

For each active goal:
- Which projects are serving it?
- Did any of those projects have meaningful activity this month?
- Are there goals with no active project at all?

Flag specifically:
- **Active projects that didn't move:** "These projects are marked Active but had no visible progress this month — what's the status?"
- **Goals with no coverage:** "This goal has no active project working toward it. Is that intentional?"
- **On-Hold projects that should be reactivated or closed:** Note any that have been sitting untouched for a while.

Ask: "Anything here that should change status — move to On Hold, get closed out, or get promoted back to Active?"

Wait for Jeff's input. For each project he wants to change, use `notion-personal__notion-update-page` to update the Status property in the Projects DB.

## Step 6: Quarterly check-in

Pull up the quarterly objectives from Step 1. For each objective or milestone:
- Show how this month contributed to it (or didn't)
- Note whether the quarter is on track, slipping, or ahead

Ask: "Given where you are in the quarter, does anything need to shift? Any quarterly objectives you want to deprioritize or accelerate?"

This is a brief alignment check, not a full quarterly planning session. If Jeff wants a deeper quarterly conversation, suggest running `/quarterly-kickoff` separately.

## Step 7: Intentions for next month

Ask: "What do you want to focus on next month?"

Guide Jeff toward 2–4 clear intentions. These should be goal-level or project-level focus areas, not task lists. Examples: "Push [project] to completion," "Get back to consistent [habit]," "Don't take on any new projects — finish what's open."

If Jeff is struggling to articulate them, offer a draft based on what you heard in Steps 3–6. Let him react and refine.

## Step 8: Draft, review, and create in Notion

Draft the Monthly Review page and show it to Jeff. Once he approves, create it in Notion using `notion-personal__notion-create-pages`.

**Do not create the page until Jeff explicitly approves the draft.**

**Where to create it:** If you found a parent page or section for monthly reviews in the Notion search from Step 1, create it there. If you can identify the relevant Quarterly Plan page, create it as a child of that page. Otherwise, create it as a standalone page — Jeff can move it.

**Page title:** `Monthly Review — [Month] [Year]` (e.g., "Monthly Review — April 2026")

**Page content:**

```
## Accomplishments

### [Goal name]
- [Project or task highlight]
- [Project or task highlight]

### [Goal name]
- ...

### Goals with no activity
- [Goal name]

---

## Reflection

**What went well:**
[Jeff's answer]

**What got stuck:**
[Jeff's answer]

**Surprises:**
[Jeff's answer]

---

## Project Status Changes
- [Project name]: Active → On Hold (reason)
- [Project name]: On Hold → Completed

---

## Quarterly Check-in
[Brief note on where the quarter stands and any adjustments]

---

## Intentions for [Next Month]
1. [Intention]
2. [Intention]
3. [Intention]
```

## Rules

- **Drive the conversation.** Ask questions one at a time, wait for real answers, guide through each section. Don't dump a wall of data at the start.
- **Don't create the Notion page until Jeff explicitly approves the draft.**
- **Update project statuses in Notion immediately** when Jeff decides on changes — don't save them all for later.
- **Be honest about stuck items and neglected goals**, but don't moralize. State what the data shows, ask what Jeff thinks, move on.
- **Keep it focused.** This is 20–30 minutes, not an hour-long retrospective.
- **If Jeff seems rushed**, compress: show accomplishments summary, ask the three reflection questions quickly, set intentions, create the page. Skip the detailed project health walkthrough if needed.
- **Degrade gracefully** if some Notion queries return no results — just note what's missing and continue.
- **The monthly review is a zoom-out.** Stay at the goal and project level. Don't get into individual tasks unless they illuminate something important.
