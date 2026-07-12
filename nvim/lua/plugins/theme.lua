local function tune_git_status_for_dark()
  -- Snacks picker git status colors, tuned to doom-one/spacemacs-ish colors.
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusAdded", { fg = "#98be65" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusModified", { fg = "#ECBE7B" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = "#98be65" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusDeleted", { fg = "#ff6c6b" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { fg = "#5B6268" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusStaged", { fg = "#98be65" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUnmerged", { fg = "#c678dd" })
end

local function tune_git_status_for_light()
  -- Seoulbones-compatible git status colors.
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusAdded", { fg = "#487249" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusModified", { fg = "#a76b48" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = "#628562" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusDeleted", { fg = "#be3c6d" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { fg = "#a5a0a1" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusStaged", { fg = "#487249" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUnmerged", { fg = "#7f4c7e" })
end

local function apply_dark_theme()
  vim.api.nvim_set_option_value("background", "dark", {})
  vim.cmd.colorscheme("doom-one")
  tune_git_status_for_dark()
end

local function apply_light_theme()
  vim.api.nvim_set_option_value("background", "light", {})
  vim.cmd.colorscheme("seoulbones")
  tune_git_status_for_light()
end

return {
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "NTBBloodbath/doom-one.nvim",
    priority = 1000,
    config = function()
      -- doom-one.nvim now configures itself through globals rather than
      -- require("doom-one").setup(). If this errors before the colorscheme is
      -- applied, Treesitter can be active while syntax highlighting appears off.
      vim.g.doom_one_cursor_coloring = false
      vim.g.doom_one_terminal_colors = true
      vim.g.doom_one_italic_comments = false
      vim.g.doom_one_enable_treesitter = true
      vim.g.doom_one_transparent_background = false
      vim.g.doom_one_diagnostics_text_color = false
      vim.g.doom_one_pumblend_enable = false
      vim.g.doom_one_pumblend_transparency = 20
      vim.g.doom_one_plugin_bufferline = true
      vim.g.doom_one_plugin_gitsigns = true
      vim.g.doom_one_plugin_telescope = false
      vim.g.doom_one_plugin_whichkey = true
      vim.g.doom_one_plugin_indent_blankline = true

      apply_dark_theme()
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = apply_dark_theme,
      set_light_mode = apply_light_theme,
    },
  },
}
