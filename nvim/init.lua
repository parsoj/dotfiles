vim.g.mapleader = " "

require("config.lazy")

vim.api.nvim_set_keymap("n", "<leader><space>", "<cmd>Telescope commands<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>h", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>j", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>k", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>l", "<C-w>l", { noremap = true, silent = true })
