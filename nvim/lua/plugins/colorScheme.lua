return {
  {
    "Rics-Dev/flow.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("flow").setup() -- Optional: for customization
      vim.cmd("colorscheme flow")
    end,
  },
  -- { "ellisonleao/gruvbox.nvim" },
  -- { "navarasu/onedark.nvim" },
  -- { 'projekt0n/github-nvim-theme', name = 'github-theme' },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "onedark",
  --   },
  -- },
  -- {
  --   "navarasu/onedark.nvim",
  --   config = function()
  --     require("onedark").setup({
  --       style = "dark",
  --       transparent = false, -- optional, keep background
  --       term_colors = true, -- optional, match terminal colors
  --     })
  --     require("onedark").load()
  --   end,
  -- },
}
