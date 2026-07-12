-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"

-- TypeScript LSP: use LazyVim's tsgo integration instead of vtsls.
-- Mason provides tsgo at ~/.local/share/nvim/mason/bin/tsgo.
vim.g.lazyvim_ts_lsp = "tsgo"

-- No left margin by default
vim.opt.signcolumn = "no"
vim.opt.number = false
vim.opt.relativenumber = false

vim.filetype.add({
  extension = {
    mdc = "markdown",
  },
})
