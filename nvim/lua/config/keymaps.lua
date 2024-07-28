-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>m", "<cmd> %bd | Dashboard <cr>", { desc = "Dashboard", noremap = true, silent = true })
vim.keymap.set(
  "n",
  "<leader>ba",
  "<cmd> %bd | e# | bd#<cr>",
  { desc = "Delete all buffers except current one", noremap = true, silent = true }
)
