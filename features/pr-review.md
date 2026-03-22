# Neovim PR Review Plugins

## ghlite.nvim
- **Repo:** https://github.com/daliusd/ghlite.nvim
- **Stars:** 80 | **Status:** Active (last commit Jan 2026)
- **Nvim:** 0.10+
- **Deps:** gh CLI, optional fzf-lua/telescope, diffview.nvim/codediff.nvim, lynx
- **Inline comments in code buffers:** Yes — loads PR comments as diagnostics via `:GHLitePRLoadComments`
- **Diff:** Delegates to diffview.nvim or codediff.nvim
- **Approach:** Augments the GitHub web UI rather than replacing it. Lightweight.
- **Limitations:** Diff output can be incorrect with gh < 2.63.0. `gf` in diff views requires PR branch checked out locally.

## github-pr-reviewer.nvim
- **Repo:** https://github.com/otavioschwanck/github-pr-reviewer.nvim
- **Stars:** 58 | **Status:** Experimental, no commits since Dec 2025
- **Nvim:** 0.11+
- **Deps:** gh CLI, optional fzf-lua/telescope/bat
- **Inline comments in code buffers:** Yes — virtual text on relevant lines
- **Diff:** Built-in inline diff (removed lines as virtual text, added lines highlighted) + split diff toggle with `<C-v>`
- **Approach:** Checks out PR as unstaged changes on a local branch. Full codebase access with LSP.
- **Limitations:** Requires clean working tree. Experimental disclaimer. Single maintainer. Requires nvim 0.11+.

## gh.nvim
- **Repo:** https://github.com/ldelossa/gh.nvim
- **Stars:** 642 | **Status:** Stalled (last commit Jan 2025, 33 open issues)
- **Nvim:** older versions supported
- **Deps:** gh CLI, litee.nvim (required), optional telescope/fzf-lua/which-key
- **Inline comments in code buffers:** No — comments live in a separate litee panel
- **Diff:** No diff-split view. Navigates actual source files with LSP.
- **Approach:** Checks out PR code locally. Full review workflow with thread resolution.
- **Limitations:** Unmaintained. No GH Enterprise support. Untracked files can break checkout. Can't see review comments on own PR.

## codereview.nvim
- **Repo:** https://github.com/afewyards/codereview.nvim
- **Stars:** 44 | **Status:** Very active (last commit Mar 2026)
- **Nvim:** 0.9+
- **Deps:** plenary.nvim
- **Inline comments in code buffers:** No — dual-pane: sidebar file tree + unified diff viewer with threaded discussions in floating windows
- **Diff:** Unified diff viewer with syntax highlighting
- **Approach:** Panel-based review. Supports GitHub AND GitLab. Has built-in AI code review (Claude, OpenAI, Ollama).
- **Limitations:** Comments in diff panels, not inline virtual text on local files.

## gh-review.nvim
- **Repo:** https://github.com/gh-tui-tools/gh-review.nvim
- **Stars:** 8 | **Status:** Brand new (created Feb 2026)
- **Nvim:** 0.10+
- **Deps:** gh CLI only (no plugin deps)
- **Inline comments in code buffers:** No — comments shown in side-by-side diff view only
- **Diff:** Side-by-side with right-side editable (checkout mode)
- **Approach:** Focused solely on reviewing a single PR. Two workflows: checkout and no-checkout.
- **Limitations:** Very new, 8 stars. No PR management (merging, labels, etc.). Explicitly scoped to review only.
