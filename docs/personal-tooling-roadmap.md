# Personal Tooling Roadmap

Tracking doc for the personal-tooling projects discussed 2026-07-17/18.
The four asks (PR-review todo list, cmux rework, quick-capture, unified planning)
resolved into one system plus one independent track.

## System map

```
capture (desktop + mobile) → AI router → Notion inbox / Linear / dispatch
feeds (Linear, GitHub review requests, access requests, Notion tasks/goals)
    → unified planning view (extends existing Notion ceremony skills)
    → execution: me, or cmux/remote workers
```

Key locked decisions:

- **Aggregate, don't own.** Work items stay in Linear/GitHub as source of truth;
  personal items stay in Notion (existing goals/inbox databases). The planning
  layer stores only its own annotations. No bidirectional sync store.
- **Personal store = Notion.** Already built: goals DB, inbox, daily-plan /
  weekly-planning / monthly-review / quarterly-kickoff / process-inbox /
  whats-next skills.
- **Mobile capture = iOS Shortcut → webhook → AI router**, Slack as the
  feedback channel (confirmations/digest), not the capture channel. The
  webhook endpoint is deliberately the seed of the future worker-dispatch API.
- **Capture metadata is the AI's job** — capture surfaces take raw text/voice/
  URL only; the router classifies, enriches, and routes (Notion inbox vs.
  Linear vs. eventually "dispatch a worker").

## Tools to build

### 1. Capture v2 (AI router + mobile) — build first
Evolve `scripts/capture/` (CaptureForInbox, link parsing → Notion inbox).
- [ ] Router service/script: raw capture in → classify (Notion inbox item,
      Linear issue, note, later: worker dispatch) → file it → confirm via Slack
- [ ] Webhook endpoint for the router (where it runs: TBD — Tailscale-reachable
      box vs. small cloud function)
- [ ] iOS Shortcut: Action Button / share sheet / dictation → webhook
- [ ] Wire existing desktop capture (launcher/CaptureForInbox) through the router
- [ ] Daily "what I filed" digest

### 2. Work-queue feed: PRs / tickets / access requests
An inbox aggregator, not a todo app — items stay at their sources.
- [ ] Feed collectors: `gh` review requests, Linear assigned issues,
      access requests (source TBD — where do these arrive?)
- [ ] Queue view (cmux pane TUI or morning digest from a scheduled agent)
- [ ] Staleness/priority annotations
- [ ] Later: hand queue items to Claude sessions pre-loaded with diff/context

### 3. Unified planning view
Extend the existing Notion ceremony skills to see both lives.
- [ ] Pull Linear goals/projects + the work queue into daily-plan / whats-next
- [ ] Score tasks against goals (surface "loudest vs. what goals say")
- [ ] Weekly view combining personal goals + work commitments
- [ ] Optional: scheduled morning agent that composes the day's view

### 4. cmux rework (independent track)
Goal: more of what I want + pave the way for remote workers and phone access.
- [ ] Inventory pass: what in cmux is load-bearing vs. incidental
- [ ] Decide architecture: local app + remote-worker layer (A) vs.
      client/server split with phone as second client (B)
- [ ] Fold in wishlist: never steal focus, browser-pane login persistence,
      sidebar status phases 2–4, commit the runClaudeHook fix
- [ ] Phone surface — likely converges with the capture webhook/router
      ("message is either a capture or a dispatch")

## Build order

1. Capture v2 (small, immediately useful, seeds the router/endpoint)
2. Work-queue feed (plugs into the same router/notification spine)
3. Planning-view extensions (needs the feeds)
4. cmux rework (own track, can proceed in parallel)
