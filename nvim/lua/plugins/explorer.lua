return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true, -- show hidden (dot) files
            ignored = true, -- show git-ignored files
            git_status = true, -- enable git status indicators
            git_status_open = true, -- show git status for files inside expanded dirs
          },
        },
      },
    },
  },
}
