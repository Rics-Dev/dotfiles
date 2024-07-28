return {
  "Rics-Dev/project-explorer.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-neo-tree/neo-tree.nvim",
  },
  opts = {
    paths = { "~/dev/*" }, -- User's custom paths
  },
  config = function(_, opts)
    require("project_explorer").setup(opts)
  end,
  keys = {
    { "<leader>fp", "<cmd>ProjectExplorer<cr>", desc = "Project Explorer" },
  },
  -- Ensure the plugin is loaded correctly
  lazy = false,
}
