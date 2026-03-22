return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      custom_highlights = function(colors)
        return {
          SnacksPickerGitStatusAdded = { fg = colors.green },
          SnacksPickerGitStatusModified = { fg = colors.yellow },
          SnacksPickerGitStatusUntracked = { fg = colors.green },
          SnacksPickerGitStatusDeleted = { fg = colors.red },
          SnacksPickerGitStatusIgnored = { fg = colors.overlay0 },
          SnacksPickerGitStatusStaged = { fg = colors.green },
          SnacksPickerGitStatusUnmerged = { fg = colors.mauve },
        }
      end,
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        vim.cmd.colorscheme("catppuccin-frappe")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        vim.cmd.colorscheme("catppuccin-latte")
      end,
    },
  },
}
