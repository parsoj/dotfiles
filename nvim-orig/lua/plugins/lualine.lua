return {

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "😄")
    end,
    enabled = false,
    dependencies = {

      "folke/trouble.nvim",
    },
  },
}
