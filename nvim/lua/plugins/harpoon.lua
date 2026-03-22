return {
  -- disable harpoon and arrow
  { "ThePrimeagen/harpoon", enabled = false },
  { "otavioschwanck/arrow.nvim", enabled = false },
  {
    "EvWilson/spelunk.nvim",
    config = function()
      require("spelunk").setup({
        enable_persist = true,
        fuzzy_search_provider = "snacks",
      })
    end,
  },
}
