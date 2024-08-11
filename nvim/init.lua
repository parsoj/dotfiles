vim.g.mapleader = " "

require("config.lazy")
require("config.legendary")

_G.dbs = {
  dev = "postgres://postgres:mypassword@localhost:5432/my-dev-db",
  staging = "postgres://postgres:mypassword@localhost:5432/my-staging-db",
  wp = "mysql://root@localhost/wp_awesome",
  anki = "sqlite:/Users/jeff/Library/Application Support/Anki2/User 1/collection.media.db2",
}

------------------------------------------------------------------------------------------
--- Libraries
--local workspace_finder = require("lua.lib.workspace_finder")

------------------------------------------------------------------------------------------
--- LSP setup

local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({ buffer = bufnr })
end)

-- (Optional) Configure lua language server for neovim
require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

--------------------------------------------------------------------------------
--- Keymaps

--- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><space>", "<cmd>Telescope commands<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fp", builtin.git_files, {})
vim.keymap.set("n", "<leader>fs", ":w<CR>", {})

--- window/pane movement
--vim.api.nvim_set_keymap("n", "<leader>h", "<C-w>h", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<leader>j", "<C-w>j", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>k", "<C-w>k", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>l", "<C-w>l", { noremap = true, silent = true })

-- Python REPL
vim.keymap.set("n", "<leader>ro", function()
  require("nvim-python-repl").open_repl()
end, { desc = "Opens the REPL in a window split" })

vim.keymap.set("v", "<leader>rv", function()
  require("nvim-python-repl").send_visual_to_repl()
end, { desc = "Send visual selection to REPL" })

vim.keymap.set("n", "<leader>rb", function()
  require("nvim-python-repl").send_buffer_to_repl()
end, { desc = "Send entire buffer to REPL" })

vim.keymap.set("n", "<leader>re", function()
  require("nvim-python-repl").send_statement_definition()
end, { desc = "Send semantic unit to REPL" })

vim.api.nvim_set_keymap("n", "<leader>ct", "<cmd>tabedit ~/.config/nvim/TODO.md<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<D-\\>", ":vsplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-->", ":split<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-w>", ":close<CR>", { noremap = true, silent = true })

vim.g.kitty_navigator_no_mappings = 1

vim.api.nvim_set_keymap("n", "<C-h>", ":KittyNavigateLeft<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":KittyNavigateDown<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":KittyNavigateUp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":KittyNavigateRight<CR>", { noremap = true, silent = true })

--vim.api.nvim_set_keymap("n", "<leader>oi", "<cmd>lua organize_imports()<CR>", { noremap = true, silent = true })

--------------------------------------------------------------------------------
