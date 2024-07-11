{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [ kanagawa-nvim ];

  vim.configRC = /* vim */ ''
    colorscheme kanagawa
  '';

  vim.startLuaConfigRC = /* lua */ ''
    require('kanagawa').setup {
        theme = "wave",
        background = {
            dark = "wave",
            light = "lotus",
        },
    }
  '';
}
