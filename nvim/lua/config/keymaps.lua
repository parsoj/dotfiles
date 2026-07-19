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
-- Includes keymaps so toggles (e.g. <leader>uw Toggle Wrap) are searchable by description.
-- Explicit confirm: execute the selection (keymap -> feed lhs, command -> cmdline),
-- since the default multi-source confirm can fall back to jumping to the definition.
vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker({
    multi = { "commands", "keymaps" },
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      if item.item and item.item.lhs then
        vim.schedule(function()
          vim.api.nvim_input(vim.api.nvim_replace_termcodes(item.item.lhs, true, true, true))
        end)
      elseif item.cmd then
        vim.schedule(function()
          vim.api.nvim_input(":")
          vim.schedule(function()
            vim.fn.setcmdline(item.cmd)
          end)
        end)
      end
    end,
  })
end, { desc = "Commands + Keymaps" })

-- Find files: prefer cwd on lowercase, project/root on uppercase.
vim.keymap.set("n", "<leader>ff", LazyVim.pick("files", { root = false }), { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>fF", LazyVim.pick("files"), { desc = "Find Files (Project)" })
