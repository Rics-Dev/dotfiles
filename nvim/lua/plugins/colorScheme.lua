return {
  -- { "ellisonleao/gruvbox.nvim" },
  -- { "navarasu/onedark.nvim" },
  -- { 'projekt0n/github-nvim-theme', name = 'github-theme' },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "onedark",
  --   },
  -- },
  -- Configure One Dark to use the "warm" style
  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup({
        style = "dark",
        transparent = false, -- optional, keep background
        term_colors = true, -- optional, match terminal colors
      })
      require("onedark").load()
    end,
  },
}
