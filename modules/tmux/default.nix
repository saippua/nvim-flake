{ pkgs, ... }:

{
  vim.startPlugins = [ pkgs.vimPlugins.tmux-nvim ];
  vim.luaConfigRC = ''
    require"tmux".setup {
      resize = {
        enable_ddfeault_keybindings = false
      }
    }
  '';
}

