-- Go indents with real tabs, 4 columns wide. The global config uses
-- expandtab + shiftwidth 2, which is wrong here; gofmt writes tabs anyway.
vim.bo.expandtab = false
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 0

-- Treesitter folds, but only when the parser is present. Indentation lives in
-- after/indent/go.lua because the runtime indent file loads after ftplugins
-- and would otherwise overwrite the indentexpr.
if pcall(vim.treesitter.get_parser, 0, 'go') then
  local win = vim.api.nvim_get_current_win()
  vim.wo[win].foldmethod = 'expr'
  vim.wo[win].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
end
