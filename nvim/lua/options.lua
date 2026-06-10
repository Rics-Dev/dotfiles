-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "

-- vim.g.netrw_banner = 0

local opt = vim.opt

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
-- opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.expandtab = true                          -- Use spaces instead of tabs
opt.ignorecase = true                         -- Ignore case
opt.inccommand = "split"                      -- preview incremental substitute
opt.laststatus = 3                            -- global statusline
opt.linebreak = true                          -- Wrap lines at convenient points
opt.mouse = "a"                               -- Enable mouse mode
opt.number = true                             -- Print line number
opt.relativenumber = true                     -- Relative line numbers
opt.scrolloff = 4                             -- Lines of context
opt.sidescrolloff = 8                         -- Columns of context
opt.smoothscroll = true
opt.shiftround = true                         -- Round indent
opt.shiftwidth = 2                            -- Size of an indent
opt.signcolumn = "yes"                        -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true                          -- Don't ignore case with capitals
opt.smartindent = true                        -- Insert indents automatically
opt.splitbelow = true                         -- Put new windows below current
opt.splitright = true                         -- Put new windows right of current
opt.tabstop = 2                               -- Number of spaces tabs count for
opt.termguicolors = true                      -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.virtualedit = "block"                     -- Allow cursor to move where there is no text in visual block mode


vim.diagnostic.config({ virtual_text = true })
