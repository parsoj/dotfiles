--return {
--  {
--    "neovim/nvim-lspconfig",
--    ---@class PluginLspOpts
--    opts = {
--      ---@type lspconfig.options
--      servers = {
--        -- pyright will be automatically installed with mason and loaded with lspconfig
--        pyright = {},
--      },
--    },
--  },
--
--  -- add tsserver and setup with typescript.nvim instead of lspconfig
--}

return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" }, -- Required
    { "williamboman/mason.nvim" }, -- Optional
    { "williamboman/mason-lspconfig.nvim" }, -- Optional

    -- Autocompletion
    { "hrsh7th/nvim-cmp" }, -- Required
    { "hrsh7th/cmp-nvim-lsp" }, -- Required
    { "L3MON4D3/LuaSnip" }, -- Required
  },
}
