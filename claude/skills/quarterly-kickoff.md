---
name: quarterly-kickoff
description: Run the quarterly planning ceremony — review the past quarter's accomplishments, goal progress, and lessons learned, then guide Jeff through selecting quarterly themes, deciding which projects to push, and creating a new Quarterly Plan page in Notion. This is a big, reflective ceremony that typically takes 1–2 hours; do not compress or skip sections.
---

# Instructions

You are running Jeff's quarterly planning ceremony. This is the highest-frequency strategic ceremony — it touches goals, identity, and the shape of the next 12 weeks. The tone should be more reflective and open-ended than daily or weekly planning. You ask questions, wait for real answers, and give Jeff space to think.

Do not rush. Do not rapid-fire questions. This ceremony assumes Jeff has carved out time for it.

## Notion database IDs

- Goals DB: `ffd1943c-0a71-439e-a38f-19c8828be29d`
- Projects DB: `5e1d336a-daeb-4daa-a6a8-8c9f22c15226`
- Tasks DB: `d790f3d1-0559-4917-a591-d77f96730806`
- Daily Plans DB: `e6edd05b-2c66-49ab-8485-f9476b2aec93`
- Weekly Plans DB: `1637ef59-5b02-44c7-aeab-0bce45350f78`
- Quarterly Plans DB: `2279f102-1ba1-49d8-ae3d-9607e48d9da5`
- Core Docs: `34e390b8-00c5-81fe-9653-ed04ffce2191`
- Values & Identity: `34e390b8-00c5-819f-aa87-e90a2fefcf25`

## Step 1: Gather context (silently, before saying anything)

Run all fetches before presenting anything. Skip gracefully if any returns no results.

**Previous quarterly plan:** Query the Quarterly Plans DB (`2279f102-1ba1-49d8-ae3d-9607e48d9da5`) using `notion-personal__notion-update-data-source` sorted by date descending. Fetch the most recent entry and read its full page content — objectives, themes, active projects, weekly template, reminders.

**Weekly Plans from the past quarter:** Query the Weekly Plans DB (`1637ef59-5b02-44c7-aeab-0bce45350f78`) for entries from approximately the last 13 weeks. Skim for patterns — what got done, what repeatedly rolled forward, what was ignored.

**All goals:** Fetch all entries from the Goals DB (`ffd1943c-0a71-439e-a38f-19c8828be29d`). Note each goal's name, status, and any metrics or notes.

**Active projects:** Query the Projects DB (`5e1d336a-daeb-4daa-a6a8-8c9f22c15226`) with a filter for Status = "Active". For each, note the name, linked goal, and any recent updates or progress signals.

**On-hold projects:** Query the Projects DB with a filter for Status = "On Hold". Note why each is on hold if available.

**Values & Identity page:** Fetch the Values & Identity page (`34e390b8-00c5-819f-aa87-e90a2fefcf25`) and read its full content.

## Step 2: Review the past quarter

### 2a. Determine the quarter being reviewed

Based on today's date, determine which quarter just ended (e.g., Q1 = Jan–Mar, Q2 = Apr–Jun, Q3 = Jul–Sep, Q4 = Oct–Dec). Use this to frame the review.

### 2b. Narrative summary

Present a narrative summary of the past quarter — not a bulleted list, a story. What got attention? What moved? What stalled? What shifted? Draw from the previous quarterly plan's objectives, the weekly plan patterns, and active project status. Be honest about gaps and stalled items without being preachy.

### 2c. Objectives check

If the previous quarterly plan had objectives, review each one:

Present a table:
| Objective | Status | Notes |
|---|---|---|
| ... | Met / Partial / Missed | your assessment |

Keep assessments honest. If something stalled, say so clearly.

### 2d. Open-ended reflection

Ask these questions **one at a time**. Wait for Jeff's full answer before moving to the next:

1. "What are you most proud of this quarter?"
2. "What disappointed you, or felt like you left it on the table?"
3. "What surprised you — a win you didn't expect, or something that derailed you?"
4. "Any patterns you noticed about how you spent your time? What pulled your attention?"

Accept short or long answers. Don't rush.

### 2e. Save the review to the previous quarterly plan

After Jeff answers all four reflection questions, update the previous quarter's Quarterly Plan page in Notion using `notion-personal__notion-update-page`. Append a "Review" section to the page content with:

- **Narrative:** your summary from 2b
- **Objectives table** from 2c
- **Reflection:** Jeff's answers to the four questions, labeled clearly

If the previous quarterly plan page doesn't exist in Notion, skip this step.

## Step 3: Values & Identity check

Present the content of the Values & Identity page (`34e390b8-00c5-819f-aa87-e90a2fefcf25`).

Ask: "Read through this. Does anything feel off or outdated? Any role that's been neglected this quarter? Anything you want to add or change?"

Give Jeff room to reflect. If he wants to update the Values & Identity page, use `notion-personal__notion-update-page` to make those changes now.

## Step 4: Goals review

Present all goals from the Goals DB. For each goal, note:
- Whether there's an active project serving it
- Whether there's been visible progress in the past quarter (based on what you gathered in Step 1)
- Whether it has no active project or habit behind it (flag these explicitly)

Ask: "Which of these goals deserve focus this coming quarter? Any you want to put on hold? Any new aspirations you want to add?"

For reference, Jeff's current goals as of April 2026:
- Get to 15% body fat
- Buy a condo
- Get fully debt free → 6-month emergency fund
- Get deep expertise in ML and LLMs
- Finish defining and implementing the Obsidian-Claude system
- Have a good reading/media system set up
- On Hold: Get a girlfriend (blocked by condo), Join an improv group

Wait for Jeff's response before moving on. If he wants to update goal statuses or add new goals, use `notion-personal__notion-update-page` or `notion-personal__notion-create-pages` in the Goals DB to make those changes.

## Step 5: Set quarterly themes

Ask: "What do you most want to accomplish in the next 12 weeks?"

Help Jeff articulate 3–5 **quarterly themes** — focus areas that will define the quarter. Each theme should:
- Be specific enough to guide project and habit decisions
- Tie to one or more goals or roles
- Be achievable in 12 weeks (not a lifetime goal restated)

Push gently if themes are vague. "Get healthier" is not a theme. "Get to sub-20% body fat through consistent lifting and tracked eating" is. Help him make them concrete.

For each theme, ask: "What would it look like at week 4? Week 8? Week 12 if this went well?"

Use these milestones to anchor the theme — they'll make it easier to track quarterly progress in weekly reviews.

## Step 6: Project decisions

Present all active and on-hold projects (from Step 1). For each, present it briefly and ask:

"Active this quarter, On Hold, or Archive?"

- **Active:** project will get real attention this quarter
- **On Hold:** intentionally paused — revisit next quarter
- **Archive:** done, abandoned, or no longer relevant

Don't force a decision on every project. If Jeff wants to skip some, that's fine — leave them as-is.

After Jeff decides, update any project status changes using `notion-personal__notion-update-page` in the Projects DB (`5e1d336a-daeb-4daa-a6a8-8c9f22c15226`).

Also ask: "Any new projects you know you'll be starting this quarter?" If yes, note them — they'll be included in the Quarterly Plan draft.

## Step 7: Weekly template

Ask: "What does a good default week look like for you this quarter?"

Help Jeff sketch a weekly template:
- **Deep work time:** when and how much
- **Protected time:** meetings-free blocks, gym, reading
- **Autopilot slots:** recurring obligations (work meetings, gym schedule, cooking nights)
- **Day themes:** any days with a specific focus (e.g., "Mondays = admin and planning, Fridays = learning")
- **Exception handling:** if a priority slips, what's the fallback?

This doesn't need to be a precise schedule — a rhythm is enough.

## Step 8: Reminders and horizon scan

Ask: "Anything that needs attention over the next 3 months? Birthdays, deadlines, events, trips, commitments?"

Note anything Jeff mentions. These will go into the Quarterly Plan as reminders. If any are time-specific, suggest creating a tickler note for them (you can do this using `notion-personal__notion-create-pages` if a Tickler database is available, or just include them in the plan).

## Step 9: Draft, review, confirm, and create in Notion

Based on everything gathered, draft the Quarterly Plan and present it to Jeff. Include all sections. Let him read, react, and revise.

**Do not create the Notion page until Jeff explicitly approves the draft.**

Once approved, create a new page in the Quarterly Plans DB (`2279f102-1ba1-49d8-ae3d-9607e48d9da5`) using `notion-personal__notion-create-pages`.

**Page properties:**
- Title: `Q[N] [YYYY]` (e.g., "Q2 2026")
- Date property: set to the first day of the quarter
- Status: "Active"

**Page content (as structured blocks):**

```
## Themes
1. **[Theme]** — [milestone at week 4], [milestone at week 8], [milestone at week 12]
2. ...
(3–5 total)

## Goals in Focus
- [goal]: [why this quarter, what movement looks like]
- ...

## Active Projects This Quarter
- [project name]: [what to push this quarter]
- ...

## On Hold This Quarter
- [project name]: [brief reason]
- ...

## Weekly Template
- Deep work: [...]
- Protected time: [...]
- Autopilot: [...]
- Day themes: [...]
- Exception plan: [...]

## Reminders
- [date or trigger]: [what]
- ...

## Notes
[anything else from the reflection — context, mindset, things to carry forward]
```

## Rules

- **Drive the conversation.** Ask questions, wait for real answers, guide section by section. Don't present everything at once.
- **Do not create the Quarterly Plan page until Jeff confirms the draft.**
- **The review gets saved to the previous quarter's page, not the new one.**
- **Be honest.** If something stalled or a goal has no active work, say so directly — not harshly, but clearly.
- **Give Jeff space.** This is a 1–2 hour ceremony. The reflection questions especially deserve real thought. Don't rush past them.
- **Degrade gracefully.** If a previous quarterly plan doesn't exist, skip the objectives check and go straight to the narrative patterns from weekly plans.
- **Update Notion as you go.** Values changes, goal status changes, and project status changes should be saved immediately after Jeff decides — don't batch everything to the end.
- **This ceremony assumes Jeff has time.** Do not offer to compress or skip sections unprompted.
