# Personal Tooling Roadmap

Tracking doc for the personal-tooling projects discussed 2026-07-17/18.
The four asks (PR-review todo list, cmux rework, quick-capture, unified planning)
resolved into one system plus one independent track.

## System map

```
capture (desktop + mobile) → AI router → Notion inbox / Linear / dispatch
feeds (GitHub PRs, Linear, Notion tasks/goals)
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
- **Mobile capture = native iOS app → HTTPS ingress → Temporal CaptureWorkflow**
  (revised 2026-07-18 from the earlier Shortcut-only plan), Slack as the
  feedback channel (confirmations/digest), not the capture channel. The app +
  ingress are deliberately the seed of the future worker-dispatch surface.
  Full design: `capture-v2-architecture.md` in the personal-tools workspace.
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

### 2. PR review queue
A unified view of PRs — this is the main, main, main thing. Items stay in
GitHub as source of truth; this is a queue view, not a todo app.
- [ ] Collector: `gh` review-requested PRs (plus my own PRs awaiting action?)
- [ ] Queue view (cmux pane TUI or morning digest from a scheduled agent)
- [ ] Staleness/priority annotations
- [ ] Later: hand PRs to Claude sessions pre-loaded with diff/context
- [ ] Future maybe: unify with tickets/access requests or a planning project —
      explicitly out of scope for v1

### 3. Unified planning view
Extend the existing Notion ceremony skills to see both lives.
- [ ] Pull Linear goals/projects + the PR queue into daily-plan / whats-next
- [ ] Score tasks against goals (surface "loudest vs. what goals say")
- [ ] Weekly view combining personal goals + work commitments
- [ ] Optional: scheduled morning agent that composes the day's view

### 4. Agent progress sync (Linear + personal tracking)
Skills/prompts/hooks so agents sync current work progress to Linear, personal
task tracking (Notion), or both — status stays current without me being the
scribe. Prior art: project-log / project-update skills (Obsidian project files).
- [ ] Decide the trigger model: explicit skill (/sync-progress), Stop-hook
      nudge, scheduled sweep of active sessions/workspaces, or a mix
- [ ] Skill: detect what the current workspace/session is working on
      (branch, workspace manifest, Obsidian project file) → map to a Linear
      issue and/or Notion task
- [ ] Write-back conventions: Linear comment vs. status change; Notion task
      update; when to touch both
- [ ] Guardrails: never invent status; agent drafts, terse factual updates
- [ ] Later: fold into cmux remote workers so they report progress the same way

### 5. cmux rework (independent track)
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
2. PR review queue (plugs into the same router/notification spine)
3. Planning-view extensions (needs the feeds)
4. Agent progress sync (independent, small enough to slot in anywhere)
5. cmux rework (own track, can proceed in parallel)
