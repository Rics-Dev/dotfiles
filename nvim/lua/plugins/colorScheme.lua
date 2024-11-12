-- return {
--   {
--     "navarasu/onedark.nvim",
--     opts = {
--       --style = "darker", -- You can try: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
--       transparent = false,
--       -- diagnostics = {
--       --   background = true, -- This will help maintain some background for diagnostic messages
--       -- },
--     },
--     priority = 1000,
--   },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "onedark",
--     },
--   },
-- }
-- gruvbox
return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })

      -- Set colorscheme after options
      vim.o.background = "dark" -- or "light" for light mode
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
