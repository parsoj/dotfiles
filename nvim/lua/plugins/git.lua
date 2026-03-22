return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
    },
    keys = {
      {
        "<leader>gb",
        function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "gitsigns-blame" then
              vim.api.nvim_win_close(win, true)
              return
            end
          end
          require("gitsigns").blame()
        end,
        desc = "Toggle Git Blame Sidebar",
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitsigns-blame",
        callback = function(ev)
          vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
        end,
      })
    end,
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gvdiffsplit", "Gwrite", "Gread", "GBrowse" },
    dependencies = { "tpope/vim-rhubarb" },
  },

  {
    "rbong/vim-flog",
    dependencies = { "tpope/vim-fugitive" },
    cmd = { "Flog", "Flogsplit", "Floggit" },
    keys = {
      { "<leader>gl", "<cmd>Flog<cr>", desc = "Git Log (Flog)" },
      { "<leader>gL", "<cmd>Flogsplit<cr>", desc = "Git Log Split" },
    },
  },
}
