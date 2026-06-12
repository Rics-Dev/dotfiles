vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
})

require('mason').setup()
-- require('mason-tool-installer').setup()


vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

require('mason-lspconfig').setup({
  automatic_enable = true,
})



vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', 'K', vim.lsp.buf.hover, 'LSP Hover')
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('n', 'gr', vim.lsp.buf.references, 'References')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('n', '<leader>cf', function() vim.lsp.buf.format() end, 'Format buffer')
    map('n', '<leader>fd', vim.diagnostic.setloclist, 'Diagnostics (loclist)')
    map('n', '<leader>e', vim.diagnostic.open_float , 'Diagnostics (float)')
    map('n', '<leader>fD', vim.diagnostic.setqflist, 'Diagnostics (quickfix)')
    map('n', '<leader>fn', function() vim.diagnostic.jump({ count = 1 }) end , 'Next diagnostic')
    map('n', '<leader>fp', function() vim.diagnostic.jump({ count = -1 }) end , 'Prev diagnostic')
  end,
})
