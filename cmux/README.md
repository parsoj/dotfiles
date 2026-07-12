# cmux Quick Reference

## Mental model

- **Workspace** = top-level item in the sidebar. Think “project/session”.
- **Surface** = tab inside a workspace, usually a terminal/browser/file/etc.
- **Pane/split** = layout inside a workspace. A surface lives in a pane.
- **Sidebar** = workspace list plus repo metadata/ports/PRs/etc.
- **Command palette** = best way to discover actions: `⌘ ⇧ P`.

Your config lives at:

```text
~/.config/cmux/cmux.json
```

## Open a new workspace

| Action | How |
|---|---|
| New workspace | `⌘ N` |
| New browser workspace | `⌘ ⌥ N` |
| Open folder as workspace | `⌘ O` |
| CLI | `cmux new-workspace` |
| CLI with dir | `cmux new-workspace --cwd ~/path/to/project` |
| UI | Click `+` in sidebar |

Useful related shortcuts:

| Action | Shortcut |
|---|---|
| Go to workspace picker | `⌘ P` |
| Jump to workspace 1–8 | `⌘ 1` … `⌘ 8` |
| Close workspace | `⌘ ⇧ W` |
| Rename workspace | `⌘ ⇧ R` |
| Edit workspace description | `⌘ ⌥ E` |
| Toggle sidebar | `⌘ B` |

## Core keybinds

### Command/app

| Action | Shortcut |
|---|---|
| Command palette | `⌘ ⇧ P` |
| Settings | `⌘ ,` |
| Reload config | `⌘ ⇧ ,` |
| New window | `⌘ ⇧ N` |
| Quit | `⌘ Q` |

### Workspaces

| Action | Shortcut |
|---|---|
| New workspace | `⌘ N` |
| New browser workspace | `⌘ ⌥ N` |
| Go to workspace | `⌘ P` |
| Workspace 1–8 | `⌘ 1` … `⌘ 8` |
| Close workspace | `⌘ ⇧ W` |
| Rename workspace | `⌘ ⇧ R` |
| Group selected workspaces | `⌘ ⇧ G` |

### Surfaces / tabs

| Action | Shortcut |
|---|---|
| New terminal surface | `⌘ T` |
| Next surface | `⌘ ⇧ ]` |
| Previous surface | `⌘ ⇧ [` |
| Surface 1–8 | `⌃ 1` … `⌃ 8` |
| Close surface/tab | `⌘ W` |
| Rename tab/surface | `⌘ R` |

### Splits / panes

| Action | Shortcut |
|---|---|
| Split right, terminal | `⌘ D` |
| Split down, terminal | `⌘ ⇧ D` |
| Split right, browser | `⌘ ⌥ D` |
| Split down, browser | `⌘ ⇧ ⌥ D` |
| Focus left/right/up/down | `⌘ ⌥ ←/→/↑/↓` |
| Zoom focused split | `⌘ ⇧ Return` |
| Equalize splits | `⌘ ⌃ =` |

### Browser

| Action | Shortcut |
|---|---|
| Open browser | `⌘ ⇧ L` |
| Address bar | `⌘ L` |
| Back / forward | `⌘ [` / `⌘ ]` |
| Reload | `⌘ R` |
| Hard reload | `⌘ ⇧ R` |
| DevTools | `⌘ ⌥ I` |
| JS console | `⌘ ⌥ C` |

### Find/search

| Action | Shortcut |
|---|---|
| Find | `⌘ F` |
| Find next | `⌘ G` |
| Find previous | `⌘ ⌥ G` |
| Find in directory | `⌘ ⇧ F` |
| Global search | `⌘ ⌥ F` |

## Customizing keybinds

Use:

```text
Settings → Keyboard Shortcuts
```

Or edit:

```text
~/.config/cmux/cmux.json
```

Example:

```jsonc
{
  "shortcuts": {
    "bindings": {
      "newSurface": ["ctrl+b", "c"],
      "toggleSidebar": "cmd+b",
      "splitRight": ""
    }
  }
}
```

Notes:

- An empty string disables a binding.
- Two-item arrays make tmux-style chords.
- cmux-owned shortcuts can be changed in Settings or `cmux.json`.
