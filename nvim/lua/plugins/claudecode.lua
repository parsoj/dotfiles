-- Claude Code IDE integration (coder/claudecode.nvim).
--
-- Runs the IDE-protocol WebSocket server inside nvim and writes a lock file
-- to ~/.claude/ide/<port>.lock. Claude runs EXTERNALLY (cmux panes) and
-- attaches with `/ide` (or `claude --ide`) — provider = "none" means the
-- plugin never opens its own embedded terminal split.
--
-- What this gives an attached claude session:
--   * current buffer / visual selection as live context
--   * proposed edits open as native diffs here (accept <leader>aa / deny <leader>ad)
--   * :ClaudeCodeSend / :ClaudeCodeAdd to push selections and files at it
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    -- Load eagerly so the server + lock file exist before any external
    -- claude tries /ide, not only after a keymap fires.
    lazy = false,
    opts = {
      auto_start = true,
      terminal = {
        provider = "none",
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
        desc = "Add file to Claude context",
      },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude context" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude diff" },
      { "<leader>aq", "<cmd>ClaudeCodeCloseAllDiffs<cr>", desc = "Close all Claude diffs" },
      { "<leader>ai", "<cmd>ClaudeCodeStatus<cr>", desc = "Claude connection status" },
    },
  },
}
