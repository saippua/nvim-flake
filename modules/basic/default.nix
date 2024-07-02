{ pkgs, ... }:

{
  vim.startPlugins = [ pkgs.vimPlugins.plenary-nvim pkgs.vimPlugins.kwbd ];

  vim.nnoremap = { "<space>" = "<nop>"; };

  vim.luaConfigRC = builtins.readFile ./config.lua;
}
