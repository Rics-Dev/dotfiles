-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function save_and_close_session()
  -- Save current session
  local current_dir = vim.fn.getcwd()
  local session_file = vim.fn.stdpath("data") .. "/sessions/" .. vim.fn.fnamemodify(current_dir, ":t") .. ".vim"
  vim.cmd("mksession! " .. session_file)

  -- Close all buffers
  vim.cmd("%bd")

  -- Change to home directory
  vim.cmd("cd ~")

  -- Open dashboard or any other start screen
  vim.cmd("Dashboard")
end

vim.keymap.set("n", "<C-j>", "10j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "10k", { noremap = true, silent = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set(
  "n",
  "<leader>m",
  save_and_close_session,
  { desc = "Save session and go to Dashboard", noremap = true, silent = true }
)
vim.keymap.set("n", "<C-b>", "<cmd>bd<cr>", { noremap = true, silent = true })
