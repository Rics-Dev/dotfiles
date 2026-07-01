local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end



-- Highlight on yank
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     vim.hl.hl_op({ higroup = 'IncSearch', timeout = 150 })
--   end,
-- })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('kickstart-highlight-yank'),
  callback = function()
    vim.hl.hl_op({ higroup = 'IncSearch', timeout = 150 })
    -- vim.hl.on_yank({ higroup = 'IncSearch', timeout = 150 })
  end,
})

