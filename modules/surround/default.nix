{ pkgs, ... }:

{
  vim.startPlugins = [ pkgs.vimPlugins.vim-surround ];
}
