-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle all left margin (line numbers, signs, diagnostics)
vim.keymap.set("n", "<leader>us", function()
  if vim.wo.signcolumn == "no" then
    vim.wo.signcolumn = "yes"
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.diagnostic.show()
  else
    vim.wo.signcolumn = "no"
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.diagnostic.hide()
  end
end, { desc = "Toggle Left Margin" })

-- Spelling (moved from <leader>us to <leader>uS)
vim.keymap.set("n", "<leader>uS", function()
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle Spelling" })

-- Spacemacs-style SPC SPC -> command palette (M-x equivalent)
vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker.commands()
end, { desc = "Commands" })

-- Find files: prefer cwd on lowercase, project/root on uppercase.
vim.keymap.set("n", "<leader>ff", LazyVim.pick("files", { root = false }), { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>fF", LazyVim.pick("files"), { desc = "Find Files (Project)" })
