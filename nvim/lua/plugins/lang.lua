return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- disable vtsls
        vtsls = { enabled = false },
        -- use tsgo instead
        tsgo = {
          cmd = { vim.fn.expand("~/.local/share/tsgo/built/local/tsgo"), "--lsp", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          -- Fix workspace folders for monorepo: force gopls to use the go.mod
          -- directory, not the git root that LazyVim detects
          before_init = function(params, config)
            local root = config.root_dir
            if root then
              params.rootUri = vim.uri_from_fname(root)
              params.workspaceFolders = {
                {
                  uri = vim.uri_from_fname(root),
                  name = root,
                },
              }
            end
          end,
        },
      },
    },
  },
  { "dag/vim-fish", ft = "fish" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "fish", "mermaid" } },
  },
}
