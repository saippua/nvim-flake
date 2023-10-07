{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [ vim-vsnip ];
}
