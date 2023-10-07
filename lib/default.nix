{ pkgs, ... }:

rec {
  myConfig = pkgs.vimUtils.buildVimPlugin {
    name = "My Neovim config";
    src = ../config;
  };

  neovim = pkgs.neovim.override {
    configure = {
      customRC = ''
        lua <<EOF
          require 'lauri'.init()
        EOF
      '';

      packages.myVimPackage = {
        start = with pkgs.vimPlugins; [
          vim-fugitive
          myConfig
        ];
        opt = [];
      };
    };
  };
}
