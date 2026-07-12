---
name: md-preview
description: Open a markdown file in cmux's rendered preview pane (live-reloading split in the current workspace). Use ONLY when the user explicitly asks to preview/render/view a markdown doc — e.g. "/md-preview", "preview this", "show me the plan rendered", "open that doc in a pane". Never invoke proactively after writing a markdown file.
---

# Markdown preview in cmux

Open a rendered, live-reloading preview of a markdown file in a split pane in
the caller's current cmux workspace, via the `cmux markdown` CLI.

## Steps

1. **Resolve the file.** Use the argument if one was given; otherwise the
   markdown file most recently written or discussed in this conversation.
   If it's genuinely ambiguous, ask. Always pass an **absolute path**.

2. **Check preconditions.** This only works from inside a cmux terminal:
   `$CMUX_WORKSPACE_ID` and `$CMUX_SOCKET_PATH` must be set. If they aren't,
   tell the user (don't guess a workspace with `--workspace`).

3. **Skip if already open.** Run `cmux list-panels` and look for an existing
   `markdown` panel for this file. If one exists, say so and stop — the panel
   live-reloads on file changes, so reopening would just stack duplicate panes.

4. **Open it:**

   ```sh
   cmux markdown open <absolute-path>
   ```

   Defaults are right: splits to the right of the current surface in the
   current workspace and does NOT steal focus. Only add options if the user
   asked for them: `--direction down|left|up`, `--focus true`.

5. Confirm with one line (file + where it opened). No further action — the
   pane tracks subsequent edits to the file automatically.

## Notes

- Rendering is native cmux (marked.js + highlight.js, GitHub CSS, Mermaid and
  Vega diagrams supported). No browser pane or external renderer needed.
- Editing the file after opening is the normal workflow — the pane updates in
  place. Prefer editing over reopening.
