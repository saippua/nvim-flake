{ pkgs, ...}:

{
  vim.startPlugins = [ pkgs.vimPlugins.vim-fugitive ];
}
