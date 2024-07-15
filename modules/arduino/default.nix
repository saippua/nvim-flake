{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [
    vim-arduino
  ];
  vim.luaConfigRC = /* lua */ ''
  '';
  
}
