{ pkgs, ... }:

{
  vim.startPlugins = [ pkgs.vimPlugins.plenary-nvim ];

  vim.nnoremap = { "<space>" = "<nop>"; };

  vim.luaConfigRC = import ./config.lua;
}
