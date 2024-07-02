{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];

  vim.configRC = ''
    " Tree-sitter based folding
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
  '';

  vim.luaConfigRC = builtins.readFile ./config.lua;
}
