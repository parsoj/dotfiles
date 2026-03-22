# Neovim Bookmark Plugins

All plugins below support **cross-file + line-level** bookmarks. Filtered to actively maintained only.

## Full-featured bookmark managers

| Plugin | Approach | Picker | Persistence |
|--------|----------|--------|-------------|
| [LintaoAmons/bookmarks.nvim](https://github.com/LintaoAmons/bookmarks.nvim) | Named bookmark lists, descriptions, tree view | Telescope | SQLite |
| [heilgar/bookmarks.nvim](https://github.com/heilgar/bookmarks.nvim) | Named lists, branch isolation | Telescope | SQLite |
| [EvWilson/spelunk.nvim](https://github.com/EvWilson/spelunk.nvim) | Stack-based organization, floating UI | Telescope/snacks/fzf-lua | File-based, git branch aware |
| [tristone13th/lspmark.nvim](https://github.com/tristone13th/lspmark.nvim) | Bookmarks survive refactoring via LSP tracking | Telescope | File-based |
| [walkersumida/fusen.nvim](https://github.com/walkersumida/fusen.nvim) | "Sticky notes" with annotations at lines | Telescope | File-based, branch aware |
| [alexekdahl/marksman.nvim](https://github.com/alexekdahl/marksman.nvim) | Auto-names bookmarks via treesitter context | Telescope/snacks | File-based with backup |

## Lightweight / minimal

| Plugin | Approach | Picker | Persistence |
|--------|----------|--------|-------------|
| [kdnk/nvim-bookmarks](https://github.com/kdnk/nvim-bookmarks) | Simple toggle, cross-buffer next/prev | — | File-based |
| [zongben/navimark.nvim](https://github.com/zongben/navimark.nvim) | Stack-scoped, custom titles | Telescope | File-based |
| [yuriescl/minimal-bookmarks.nvim](https://github.com/yuriescl/minimal-bookmarks.nvim) | Intentionally barebones add/remove/list | — | File-based |

## Enhanced native marks

| Plugin | Approach | Picker | Persistence |
|--------|----------|--------|-------------|
| [chentoast/marks.nvim](https://github.com/chentoast/marks.nvim) | Enhances vim marks + adds bookmark groups | Quickfix | Native shada |
| [2KAbhishek/markit.nvim](https://github.com/2KAbhishek/markit.nvim) | Fork of marks.nvim with fixes, project-wide cycling | pickme.nvim | Native shada |
| [fnune/recall.nvim](https://github.com/fnune/recall.nvim) | Thin wrapper, auto-assigns global mark letters | Telescope/snacks | Native shada |
| [nkey-ops/extended-marks.nvim](https://github.com/nkey-ops/extended-marks.nvim) | Multi-char mark names (up to 30 chars) | — | File-based |
| [mohseenrm/marko.nvim](https://github.com/mohseenrm/marko.nvim) | Per-project shada isolation for global marks | — | Per-project shada |
| [BartSte/nvim-project-marks](https://github.com/BartSte/nvim-project-marks) | Per-project shada isolation | — | Per-project shada |

## Trail/history-based

| Plugin | Approach |
|--------|----------|
| [LeonHeidelbach/trailblazer.nvim](https://github.com/LeonHeidelbach/trailblazer.nvim) | Breadcrumb trail with 9 traversal modes, named stacks |

## Top picks

1. **spelunk.nvim** — most actively maintained, supports snacks picker (already in use), stack-based organization
2. **LintaoAmons/bookmarks.nvim** — most feature-complete, named lists, tree view
3. **recall.nvim** — thinnest layer for "mark this line, jump to it from anywhere"

## Excluded (do NOT meet both criteria)

- **harpoon** — file-level only
- **grapple.nvim** — file-level tagging
- **arrow.nvim** — file-level cross-file; per-buffer line bookmarks are buffer-local only
- **vim-bookmarks** — cross-file only via quickfix workaround; unmaintained
- **track.nvim** — marks scoped to current file only
- **tide.nvim** — file-level only
- **warp.nvim** — file-level only
- **marlin.nvim** — file-level only
- **dartboard.nvim** — file-level only
- **filemarks.nvim** — file and directory level only
