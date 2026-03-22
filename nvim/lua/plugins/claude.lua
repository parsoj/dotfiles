return {
  -- claudecode.nvim - integrates with Claude Code CLI
  {
    dir = "/Users/jeff/code/workspaces/claude-vim-differ/ide-protocol-claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false,
    opts = {
      terminal = {
        provider = "none",
      },
      diff_opts = {
        layout = "inline",
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      {
        "<leader>af",
        function()
          vim.fn.system("tmux select-pane -t $(tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep -i claude | head -1 | awk '{print $1}')")
        end,
        desc = "Focus Claude pane",
      },
    },
  },

  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
  },

  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
