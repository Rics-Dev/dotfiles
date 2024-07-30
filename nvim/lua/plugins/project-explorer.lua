return {
  "Rics-Dev/project-explorer.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "prichrd/netrw.nvim",
  },
  opts = {
    paths = { "~/dev/*" },
  },
  config = function(_, opts)
    require("project_explorer").setup(opts)
  end,
  keys = {
    { "<leader>fp", "<cmd>ProjectExplorer<cr>", desc = "Project Explorer" },
  },
  lazy = false,
}
