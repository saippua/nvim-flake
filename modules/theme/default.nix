{ pkgs, ... }:
{
      vim.configRC = ''
    colorscheme kanagawa
  '';
  
  vim.startPlugins = with pkgs.vimPlugins; [ kanagawa-nvim ];

  vim.startLuaConfigRC = ''
    require('kanagawa').setup {
        theme = "wave",
        background = {
            dark = "wave",
            light = "lotus",
        },
    }
  '';
}
