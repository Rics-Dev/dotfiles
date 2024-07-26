return {
  -- toggleTerm plugin
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    keys = {
      {
        "<leader>tt",
        "<cmd>ToggleTerm size=20 dir=lfs.currentdir() direction=horizontal name=desktop<cr>",
        desc = "open a horizontal terminal",
      },
      {
        "<leader>tv",
        "<cmd>ToggleTerm size=70 dir=~/Desktop direction=vertical name=desktop<cr>",
        desc = "open a vertical terminal",
      },
    },
  },
}
