-- Minimal Python LSP: ruff only (lint + format + hover + code actions).
-- Ruff 0.15+ ships `ruff server`; the old `ruff-lsp` package is deprecated.
-- No plugin needed: Neovim 0.11+ has vim.lsp.config / vim.lsp.enable built in.
--
-- lazy.nvim requires each file in lua/plugins/ to return a spec table, so the
-- real work lives in a `config` function on a no-op plugin spec.

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
})

vim.lsp.enable('ruff')

-- Keymaps that only make sense once a language server is attached.
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Python LSP keymaps',
  callback = function(args)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
    end

    map('K', vim.lsp.buf.hover, 'Hover docs')
    map('gr', vim.lsp.buf.rename, 'Rename symbol')
    map('ca', vim.lsp.buf.code_action, 'Code action')
    map('gl', vim.diagnostic.open_float, 'Line diagnostics')
    map('[d', function() vim.diagnostic.jump({ count = -1 }) end, 'Prev diagnostic')
    map(']d', function() vim.diagnostic.jump({ count = 1 }) end, 'Next diagnostic')
  end,
})

return {}