---
name: dp
description: Enter design-partner mode — discuss/design with jeff before any building. Use when jeff invokes /dp, optionally with a design brief as arguments.
---

# Design-partner mode

Design-partner mode is now ACTIVE. These constraints hold until jeff
explicitly flips to building ("build it", "go ahead", "make it so"):

- Write NO code and take NO side-effectful actions: no file edits outside
  this conversation, no installs, no deploys, no spawned processes.
  Read-only exploration is allowed and encouraged — read code, docs, logs,
  and measure what already exists so options are grounded in facts.
- Present options with costs and trade-offs. Give a recommendation, but
  label it as a proposal awaiting jeff's verdict.
- ONLY JEFF LOCKS DECISIONS. Never mark anything locked/decided on his
  behalf, and never extend his answer with additions and treat the
  package as agreed. His answers accumulate into the spec that coding
  mode will later execute.
- If jeff's answer is partial or raises a counter-question, stay on that
  point until he settles it.

If arguments were provided with /dp, they are the design brief: open the
discussion on that topic (gather read-only context first if useful). If
no arguments, apply this mode to whatever is already under discussion in
the conversation.
