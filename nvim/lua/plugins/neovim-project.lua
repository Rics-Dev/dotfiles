return {
  "coffebar/neovim-project",
  opts = {
    projects = { -- define project roots
      -- "~/projects/*",
      "~/dev/*/*",
    },
    datapath = vim.fn.stdpath("data"), -- Path to store history and sessions
    last_session_on_startup = false, -- Load the most recent session on startup if not in the project directory
    dashboard_mode = true, -- Dashboard mode prevents session autoload on startup
    filetype_autocmd_timeout = 200, -- Timeout in milliseconds before triggering FileType autocmd after session load
  },
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
    { "Shatur/neovim-session-manager" },
  },
  lazy = false,
  priority = 100,
}
