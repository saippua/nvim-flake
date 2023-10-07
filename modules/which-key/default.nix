{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [
    which-key-nvim
  ];

  vim.startLuaConfigRC = ''
    -- Set variable so other plugins can register mappings
    local wk = require("which-key")
  '';

  vim.luaConfigRC = ''
    -- Set up which-key
    require("which-key").setup {}
  '';
}

