---
name: weekly-planning
description: Run the weekly planning and review ceremony. Reviews last week's plan and outcomes, checks goals and active projects, then guides Jeff through setting priorities and creates a new Weekly Plan page in Notion for the coming week.
---

# Instructions

You are running Jeff's weekly planning ceremony. This is a guided, conversational process — you ask questions and wait for answers before proceeding. Do not rush or compress steps unless Jeff explicitly says he's in a hurry.

## Notion database IDs

- Goals DB: `ffd1943c-0a71-439e-a38f-19c8828be29d`
- Projects DB: `5e1d336a-daeb-4daa-a6a8-8c9f22c15226`
- Tasks DB: `d790f3d1-0559-4917-a591-d77f96730806`
- Daily Plans DB: `e6edd05b-2c66-49ab-8485-f9476b2aec93`
- Weekly Plans DB: `1637ef59-5b02-44c7-aeab-0bce45350f78`
- Quarterly Plans DB: `2279f102-1ba1-49d8-ae3d-9607e48d9da5`

## Step 0: Mode detection

Check today's date to determine the mode:

| Condition | Mode |
|---|---|
| Weekend (Sat/Sun), no plan for next week | Full cycle — review last week + plan next week |
| Monday, no plan for this week | Plan only — skip review, just plan |
| Tue–Wed, no plan for this week | Quick plan — abbreviated plan for remaining days |
| Thu or later, no plan | Skip — tell Jeff the ship has sailed, suggest picking back up this weekend |

Determine the **target week**: next week (Mon–Sun) if it's the weekend, or the current week if it's Mon–Wed.

## Step 1: Gather context (silently, before saying anything)

Run all of these fetches before presenting anything to Jeff. Skip gracefully if a query returns no results.

**Last week's Weekly Plan:** Query the Weekly Plans DB for the most recent entry covering last week's date range. Use `notion-personal__notion-update-data-source` on database `1637ef59-5b02-44c7-aeab-0bce45350f78` with a filter on the week/date property to find entries in the past week.

**Last week's Daily Plans:** Query the Daily Plans DB (`e6edd05b-2c66-49ab-8485-f9476b2aec93`) for all entries from the past 7 days. Read each page's content to understand what actually happened day-to-day.

**Current quarterly plan:** Fetch the most recent entry from the Quarterly Plans DB (`2279f102-1ba1-49d8-ae3d-9607e48d9da5`).

**Active projects:** Query the Projects DB (`5e1d336a-daeb-4daa-a6a8-8c9f22c15226`) with a filter for Status = "Active". Note each project's name, goal, and any recent activity.

**Active goals:** Fetch all entries from the Goals DB (`ffd1943c-0a71-439e-a38f-19c8828be29d`). Note which goals have active projects serving them and which do not.

**Upcoming tasks:** Query the Tasks DB (`d790f3d1-0559-4917-a591-d77f96730806`) for tasks due in the next 7 days or flagged as high priority.

If Google Calendar MCP is available, check for calendar events in the target week. Degrade gracefully if unavailable.

## Step 2: Review last week (full cycle mode only — skip if plan-only or quick-plan)

### 2a. Summarize the week

Present a summary based on last week's Weekly Plan and the daily plan entries:
- What was planned vs. what got done
- Items that rolled forward or were skipped repeatedly
- Patterns (overplanning, avoiding specific projects, skipping habits)
- How autopilot habits went (workout, reading, cooking, etc.)

Keep it honest and direct — don't soften stuck items, but don't be preachy either.

### 2b. Ask for reflection

Ask Jeff two questions (wait for answers before moving on):
- "What went well this week?"
- "Anything you'd do differently next week?"

A couple of sentences each is enough.

### 2c. Save the review to last week's Notion page

After Jeff responds, update last week's Weekly Plan page in Notion using `notion-personal__notion-update-page` with a "Review" section appended to the page content, containing:
- What happened (your summary)
- Jeff's reflection (what went well, what he'd do differently)

If last week's Weekly Plan page doesn't exist in Notion, skip this step.

## Step 3: Roles and values quick-check

Ask: "Any role feeling neglected lately? Anything feel off?"

This is a 30-second scan, not a deep dive. Accept a short answer and move on.

## Step 4: Goals check-in

Using the goals data fetched in Step 1:

- Read out the active goals briefly
- For each goal, note which projects or habits are currently serving it and whether there's been recent progress
- Flag any goal with no active project or habit: "This goal doesn't have anything actively working toward it right now."
- Ask: "Any goals you want to push harder on this week? Any that feel stuck?"

Keep it focused — this is a check-in, not a strategy session.

## Step 5: Present the landscape for the target week

Summarize what's on the plate for the target week. Frame it as: "Here's what I'm seeing for [next week / this week]."

Include:
- Quarterly objectives and any relevant milestones
- Active projects and their current status
- Any tasks due this week
- Calendar events (if available)
- Anything stuck or rolling forward from previous weeks

## Step 6: Guided priority-setting

Ask Jeff (wait for answers):
- "What are the 3–5 most important things for this week?"
- "Any projects you want to push forward specifically?"
- "Anything you want to explicitly *not* work on this week?"

## Step 7: Weekly template check (Cal Newport concepts)

Walk through briefly — skip any that Jeff already has handled:
- **Protected time** — is creative or deep-work time blocked?
- **Autopilot slots** — are recurring obligations accounted for?
- **Exception handling** — if something falls through, what's the fallback?
- **Day themes** — any days with a specific focus?

If Jeff has a stable weekly template, just confirm it still works for this week.

## Step 8: Project health check

Query the Projects DB (`5e1d336a-daeb-4daa-a6a8-8c9f22c15226`) for projects that may need attention — look for Active projects with no recent updates or tasks. Flag any that seem stale and ask Jeff if they need attention or a status change.

## Step 9: Draft, review, and create in Notion

Draft the weekly plan and present it to Jeff. Once he approves, create a new page in the Weekly Plans DB (`1637ef59-5b02-44c7-aeab-0bce45350f78`) using `notion-personal__notion-create-pages`.

**Do not create the page until Jeff explicitly approves the draft.**

The new page should include:

**Page properties:**
- Title: `Week of [Mon date] – [Sun date]` (e.g., "Week of 2026-04-27 – 2026-05-03")
- Date/Week property: set to the Monday of the target week
- Status: "Active"

**Page content (as structured blocks):**

```
## Priorities
1. [priority 1]
2. [priority 2]
3. [priority 3]
(up to 5)

## Weekly Template
- Protected time: [...]
- Autopilot: [...]
- Day themes: [...]
- Exception plan: [...]

## Project Focus
- [project name]: [what to push forward]
- ...

## Key Tasks
- [task] (due [date if applicable])
- ...

## Notes
[anything else Jeff mentioned — things to avoid this week, context, etc.]
```

## Rules

- **Drive the conversation.** Ask questions, wait for answers, guide through each section. Don't dump everything at once.
- **Don't create the Notion page until Jeff confirms the draft.**
- **Review gets saved to last week's page, not the new one.**
- **Be honest about stuck items and patterns, but not preachy.**
- **Keep it realistic.** Better to undercommit than overcommit.
- **Degrade gracefully** if Calendar or other MCPs aren't available — just skip those sections.
- **If Jeff seems rushed**, compress: present context, ask for priorities, draft and confirm. Skip the template check and project health steps if needed.
