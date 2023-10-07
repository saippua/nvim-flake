{ pkgs, ... }:

{
  vim.startPlugins = [ pkgs.vimPlugins.tmux-nvim ];
  vim.luaConfigRC = ''
    require"tmux".setup { }
  '';
}

