return {
  { "EdenEast/nightfox.nvim" },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "cormacrelf/dark-notify",
    opts = {
      schemes = {
        dark = {
          colorscheme = "tokyonight-moon",
        }, -- Use your dark colorscheme here
        light = {
          colorscheme = "dayfox",
          background = "light",
        },
      },
      onchange = function(mode)
        -- Optional: Add any additional logic when the theme changes between light and dark
      end,
    },
    config = function(_, opts)
      local dn = require("dark_notify")
      dn.run(opts)
    end,
  },
}
