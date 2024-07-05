vim.g.mapleader = " "

require("config.lazy")

vim.api.nvim_set_keymap("n", "<leader><space>", "<cmd>Telescope commands<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>h", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>j", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>k", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>l", "<C-w>l", { noremap = true, silent = true })

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

-- vim.keymap.set("n", [your keymap], function() require('nvim-python-repl').toggle_execute() end, { desc = "Automatically execute command in REPL after sent"})
-- vim.keymap.set("n", [your keymap], function() require('nvim-python-repl').toggle_vertical() end, { desc = "Create REPL in vertical or horizontal split"})
