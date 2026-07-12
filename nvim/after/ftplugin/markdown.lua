-- Markdown folding by heading level.
--
-- Uses Neovim's native fold commands:
--   za toggles the fold under the cursor
--   zM closes all folds
--   zR opens all folds

function _G.markdown_heading_foldexpr(lnum)
  local line = vim.fn.getline(lnum)
  local hashes = line:match("^(#+)%s")

  if hashes then
    return ">" .. #hashes
  end

  -- Keep non-heading lines in the current fold.
  return "="
end

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.markdown_heading_foldexpr(v:lnum)"
vim.opt_local.foldlevel = 99
vim.opt_local.foldlevelstart = 99
vim.opt_local.foldenable = true
