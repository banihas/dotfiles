-- Runs after $VIMRUNTIME/indent/go.vim, which installs the built-in GoIndent.
if pcall(vim.treesitter.get_parser, 0, 'go') then
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end
