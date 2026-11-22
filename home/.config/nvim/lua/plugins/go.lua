-- Go: gopls through the built-in LSP client, treesitter, completion, neotest.
-- Formatting is plain gofmt on save (gopls's default formatter).

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})

vim.lsp.enable('gopls')

-- gofmt on save, once gopls is attached to the buffer.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  desc = 'gofmt on save',
  callback = function(args)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = args.buf,
      callback = function()
        if #vim.lsp.get_clients({ bufnr = args.buf, method = 'textDocument/formatting' }) == 0 then
          return
        end
        vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 2000 })
      end,
    })
  end,
})

return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    event = 'InsertEnter',
    opts = {
      keymap = { preset = 'default' },
      sources = { default = { 'lsp', 'path', 'buffer' } },
      completion = { documentation = { auto_show = true } },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()
      require('nvim-treesitter').install({ 'go', 'gomod', 'gosum', 'gowork', 'gotmpl' })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'go', 'gomod', 'gosum', 'gowork', 'gotmpl' },
        desc = 'Treesitter highlighting',
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-neotest/neotest-go',
    },
    keys = {
      { '<leader>tt', function() require('neotest').run.run() end, desc = 'Test nearest' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Test file' },
      { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Test summary' },
      { '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = 'Test output' },
      { '<leader>tS', function() require('neotest').run.stop() end, desc = 'Stop test' },
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-go')({ args = { '-count=1' } }),
        },
      })
    end,
  },
}
