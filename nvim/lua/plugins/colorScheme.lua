return {
  {
    "navarasu/onedark.nvim",
    opts = {
      --style = "darker", -- You can try: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
      transparent = false,
      -- diagnostics = {
      --   background = true, -- This will help maintain some background for diagnostic messages
      -- },
    },
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
