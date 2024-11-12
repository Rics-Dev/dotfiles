local function open_dotfiles()
  -- Open FZF-lua file picker in the specified directories
  require("fzf-lua").files({
    cwd = "~/.dotfiles",
    search_dirs = { "~/.dotfiles", "~/.config" },
    actions = {
      ["default"] = function(selected)
        -- If we have a selection
        if selected and selected[1] then
          -- Change to the dotfiles directory
          vim.cmd("cd ~/.dotfiles")
          -- Open the selected file
          vim.cmd("edit " .. selected[1])
        end
      end,
    },
  })
end

local function get_cwd()
  local cwd = vim.fn.getcwd()
  local home = vim.fn.expand("~")
  if cwd == home then
    cwd = "Home"
  end
  return cwd
end

local function update_footer()
  local cwd = get_cwd()
  local footer = { "Current Directory: " .. cwd }
  vim.api.nvim_set_var("dashboard_footer", footer)
end

local function refresh_dashboard()
  if vim.bo.filetype == "dashboard" then
    -- Close the current dashboard buffer and reopen it
    vim.cmd("bdelete")
    vim.cmd("Dashboard")
  end
end

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    update_footer()
    --    refresh_dashboard()
  end,
})

return {
  "nvimdev/dashboard-nvim",
  lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  opts = function()
    local logo = [[
██████╗ ██╗ ██████╗███████╗    ██████╗ ███████╗██╗   ██╗
██╔══██╗██║██╔════╝██╔════╝    ██╔══██╗██╔════╝██║   ██║
██████╔╝██║██║     ███████╗    ██║  ██║█████╗  ██║   ██║
██╔══██╗██║██║     ╚════██║    ██║  ██║██╔══╝  ╚██╗ ██╔╝
██║  ██║██║╚██████╗███████║    ██████╔╝███████╗ ╚████╔╝ 
╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝    ╚═════╝ ╚══════╝  ╚═══╝  
    ]]
    logo = string.rep("\n", 8) .. logo .. "\n\n"
    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = "ProjectExplorer", desc = "  Project Explorer", icon = "", key = "p" },
          { action = open_dotfiles, desc = "  Dotfiles", icon = ".", key = "d" },
          { action = 'lua LazyVim.pick()()', desc = " Find File", icon = " ", key = "f" },
          { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
          { action = 'lua LazyVim.pick("oldfiles")()', desc = " Recent Files", icon = " ", key = "r" },
          { action = 'lua LazyVim.pick("live_grep")()', desc = " Find Text", icon = " ", key = "g" },
          { action = 'lua LazyVim.pick.config_files()()', desc = " Config", icon = " ", key = "c" },
          { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras", desc = " Lazy Extras", icon = " ", key = "x" },
          { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
          { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit", icon = " ", key = "q" },
        },
        footer = function()
          return vim.api.nvim_get_var("dashboard_footer")
        end,
      },
    }
    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end
    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    -- Initialize the footer
    update_footer()

    return opts
  end,
}
