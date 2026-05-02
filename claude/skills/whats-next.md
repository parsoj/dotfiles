---
name: whats-next
description: Answers "what should I work on right now?" by checking for overdue ceremonies (daily plan, weekly plan, monthly/quarterly reviews) and surfacing the highest-priority unblocked tasks across active projects. Run this at the start of any work session.
---

# Instructions

You are running the **whats-next** skill. Your job is to do a quick inventory of Jeff's life management system, tell him what needs attention, and offer to walk through it in priority order.

All data lives in Notion. Access it via the `notion-personal` MCP server.

---

## Step 1 — Establish time context

Note the current date, day of week, and time of day. You will use these to evaluate ceremony triggers below.

---

## Step 2 — Scan for ceremony triggers

Check each item below in order. Earlier items are higher priority.

### a. Inbox

Fetch the Inbox page (`34e390b8-00c5-8131-916a-dd5616fbb7af`) using `notion-personal__notion-fetch`. Count any items or notes present that appear unprocessed. If the inbox has content, flag it: "Inbox has items to process."

### b. Daily Plan

Query the Daily Plans DB (`e6edd05b-2c66-49ab-8485-f9476b2aec93`) using `notion-personal__notion-update-data-source` with a filter on the Date property.

Apply this trigger logic:
- **After 5:30pm**: Check if a plan exists for *tomorrow*. If not → suggest running `/daily-plan` (evening planning mode).
- **Before noon**: Check if a plan exists for *today*. If not → suggest running `/daily-plan` (morning planning mode).
- **After noon, before 5:30pm**: If no plan exists for today, do not suggest — the window has passed.

### c. Weekly Plan

Query the Weekly Plans DB (`1637ef59-5b02-44c7-aeab-0bce45350f78`) using `notion-personal__notion-update-data-source`. Filter for a plan covering the current week (or next week on weekends). Check the Week Start date property.

Apply this trigger logic:
- **Saturday or Sunday**: Check if a plan exists for *next* week. If not → suggest `/weekly-planning` (full cycle: review + plan).
- **Monday**: Check if a plan exists for *this* week. If not → suggest `/weekly-planning` (plan only — urgent).
- **Tuesday or Wednesday**: Check if a plan exists for *this* week. If not → suggest `/weekly-planning` (quick plan for remaining days).
- **Thursday or Friday**: If no plan for this week, do not suggest — ship has sailed.

### d. Monthly Review

Query the Quarterly Plans DB (`2279f102-1ba1-49d8-ae3d-9607e48d9da5`) or search for monthly review pages using `notion-personal__notion-search` with the query "monthly review". Find the most recent monthly review. If 4+ weeks have passed since the last one (or none exists), flag it: "Monthly review is due." Best suggested after weekly review is done.

### e. Quarterly Kickoff

Query the Quarterly Plans DB (`2279f102-1ba1-49d8-ae3d-9607e48d9da5`) using `notion-personal__notion-update-data-source`. Check if a plan exists for the current quarter.

- If today is on or after 2026-07-01 and no Q3 2026 quarterly plan exists → nudge: "New quarter — time to schedule your quarterly offsite. Run `/quarterly-kickoff` when you're ready, or pick a weekend and put it on the calendar."
- NOTE: Once Jeff completes his first quarterly kickoff, remove the hardcoded 2026-07-01 date and replace with general logic: detect if the current quarter has a plan page. Keep nudging each session until the plan exists.
- This is a persistent reminder, not a blocking ceremony. Mention it but do not chain it.

### f. Project Reviews

Query the Projects DB (`5e1d336a-daeb-4daa-a6a8-8c9f22c15226`) using `notion-personal__notion-update-data-source` with filter: Status = "Active". For each active project, check the "Last Reviewed" date property (or equivalent). Flag any projects that haven't been reviewed in 2+ weeks as "overdue for review." List them by name. Mention these in the summary — do not chain them.

### g. Stale Projects

While reviewing active projects above, also flag any projects with no recent activity (no task updates, no log entries, no page edits) in the past 2 weeks. List them as "possibly stale." Mention in summary — do not chain.

---

## Step 3 — Present a prioritized summary

Show a short, scannable summary of everything that needs attention. Use the priority order below. For each item, state what it is and why it's flagged. Keep it brief — one line per item where possible.

**Priority order:**
1. Inbox (if has items — informs other ceremonies)
2. Quarterly kickoff nudge (if due — persistent, not blocking)
3. Weekly plan (if weekend or Monday and no plan exists)
4. Daily plan (if morning/evening window and no plan exists)
5. Monthly review (if due)
6. Project reviews (overdue ones — mention only)
7. Stale projects (mention only)

If everything is caught up, say so: "Everything looks caught up. No ceremonies due and no flagged projects."

---

## Step 4 — Offer to walk through it

After presenting the summary, ask:

> "Want to start working through these? I'll take you through them in order."

---

## Step 5 — Ceremony chaining (if user says yes)

Walk through each actionable ceremony in sequence:

1. **Start with the highest-priority item.** Run the ceremony skill inline — don't just tell Jeff to run it, actually begin the ceremony flow right here.
2. **When that ceremony is done**, briefly note what's next: "That's the inbox done. Next up: weekly review. Ready?"
3. **Wait for confirmation** before starting each ceremony. Jeff can skip, stop, or reorder at any point.
4. **When everything is done**, say: "You're caught up."

**Chainable ceremonies (run inline in order):**
1. Inbox processing (`/process-inbox`)
2. Weekly planning/review (`/weekly-planning`) — if weekend or Monday
3. Daily plan (`/daily-plan`) — morning or evening mode as appropriate
4. Monthly review (`/monthly-review`) — if due

**Not chained — mention only:**
- Quarterly kickoff nudge
- Project reviews
- Stale projects

---

## Rules

- Keep the initial summary short and scannable.
- Don't nag — surface what's there and let Jeff decide.
- If everything is caught up, say so clearly.
- When chaining, each ceremony follows its own full flow (guided conversation, questions, drafting, confirmation). Do not compress or shortcut them.
- Jeff is always in control — he can skip, stop, or say "just show me the list" at any point.
- When querying Notion databases, use `notion-personal__notion-update-data-source` for filtered queries and `notion-personal__notion-fetch` for fetching a specific page by ID.
