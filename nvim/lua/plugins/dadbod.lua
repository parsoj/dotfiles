return {
  {
    "tpope/vim-dadbod",
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Database UI" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod"
      vim.g.dbs = {
        {
          name = "workflow_queue_local",
          url = "postgresql://tennr_workflow_queue_user:$LOCAL_QUEUE_PASSWORD@localhost:5431/workflow_queue",
        },
      }
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    lazy = true,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          require("cmp").setup.buffer({
            sources = { { name = "vim-dadbod-completion" } },
          })
        end,
      })
    end,
  },
}
