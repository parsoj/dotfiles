-- MDX support via davidmh/mdx.nvim:
--   * registers the "mdx" filetype for *.mdx
--   * uses the markdown treesitter parser as the base language
--   * ships injection queries so ESM import/export blocks and JSX tags
--     highlight as typescript/tsx inside mdx buffers
return {
  {
    "davidmh/mdx.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- The plugin just defines a filetype + queries; cheap to load at startup.
    lazy = false,
    init = function()
      -- mdx.nvim's injections target "typescript"/"typescriptreact"; make sure
      -- typescriptreact resolves to the tsx parser.
      vim.treesitter.language.register("tsx", "typescriptreact")
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "mdx" },
    opts = {
      file_types = { "markdown", "mdx" },
    },
  },
}
