---
name: answer-onebyone
description: Step through open questions from earlier in this session one at a time, collecting free-form answers from the user, then continue work with everything resolved. Use when the user invokes /answer-onebyone, or says things like "let's go through these one at a time", "answer these one by one", or "walk me through the questions" after a reply that raised multiple questions or decisions.
---

# Answer one-by-one: sequential free-form Q&A

The user just received (or points at) a message in this session that raised multiple
open questions or decisions. Instead of making them write one big numbered reply,
interview them: one question per turn, free-form answers, then proceed with all
answers in hand.

## Hard rules

- **NEVER use AskUserQuestion.** No multiple choice, no "Option A/B/C" framing, no
  answer menus of any kind. Every question is answered in the user's own words.
  If the user seems unsure, offer your own recommendation in prose — never options.
- **One question per turn.** Never put two questions on the table at once, even if
  they're closely related. You may note a relationship ("your answer here constrains
  Q3") but only the current question is open for discussion.
- **Stay until resolved.** If the user's answer is partial, raises a counter-question,
  or asks for more context, keep discussing the CURRENT question. Do not advance
  until it's genuinely settled or the user defers it.

## Flow

### 1. Extract

Source: the most recent assistant message containing open questions, unless the user
points at a different message or pastes text. Extract every open question or pending
decision — numbered ones, but also implicit ones ("we still need to decide X",
"unclear whether Y"). Do NOT include things already resolved, explicitly deferred,
or empirical unknowns that testing/experiment will answer (only include those if the
user is being asked to make a judgment call about them).

### 2. Open — list + first question in one message

In a single message:
- A numbered one-liner list of every extracted question ("The open questions: ...").
  Invite corrections briefly: the user can say "drop N" or "add: ..." at any point
  during the interview, not just now.
- Then immediately pose **Question 1 of N**: restate the question with enough
  surrounding context to answer it without scrolling back. If the original message
  embedded a proposal or recommendation for it, surface that explicitly ("Proposal
  on the table: ...") so the user can simply say "agreed".
- Stop and wait. Do not answer any questions yourself. Do not start any work.

### 3. Step

For each subsequent turn:
- If resolved: confirm with a one-line lock-in ("**Locked: daemon hides; PREPARED
  begins after hide.**"), then pose the next question in the same message
  ("**Question 2 of 3:** ...").
- If not resolved: iterate on the current question only.

Understand this shorthand from the user:
- **"agreed" / "yes" / "sgtm"** — accept the proposal that was on the table.
- **"you decide"** — make the call yourself; state your pick in the lock-in line.
- **"skip" / "defer"** — record it as explicitly unresolved and move on.
- **Out-of-order or batch answers** ("for 2 and 3: ...") — lock those in too,
  then return to the lowest-numbered open question.
- **"drop N" / "add: ..."** — amend the question list mid-flight.

### 4. Close — compile and proceed

Once every question is locked or deferred, post a **Decisions** summary: each
question as a one-liner with its resolved answer (deferred items marked as such).
Then proceed with the work as normal — continue whatever the original message was
building toward, applying all the answers. Do not ask "shall I proceed?"; the
interview ending IS the go signal.

## Tone

This is a working conversation, not a form. Keep question framing tight — the
context the user needs, nothing more. Push back or add analysis during iteration
when useful; the step structure constrains sequencing, not thinking.
