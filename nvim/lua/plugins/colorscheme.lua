return {
  -- flow theme
  {
    "Rics-Dev/flow.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("flow").setup({
        transparent_background = true,
      })
      vim.cmd("colorscheme flow")
    end,
  },
  -- {
  -- "olimorris/onedarkpro.nvim",
  -- lazy = false,
  -- priority = 1000,
  -- config = function()
  --   require("onedarkpro").setup({
  --   })
  --   vim.cmd("colorscheme onedark")
  -- end,
  --  },
  -- {
  --   "marko-cerovac/material.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("material").setup({
  --     })
  --       vim.cmd("colorscheme material-deep-ocean")
  --   end,
  -- },

  -- {
  --   "metalelf0/black-metal-theme-neovim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("black-metal").setup({
  --       theme = "khold",
  --     })
  --     require("black-metal").load()
  --   end,
  -- }
}
