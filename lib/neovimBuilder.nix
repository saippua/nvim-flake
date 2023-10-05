{ pkgs, lib ? pkgs.lib, ... }:

{ }:

let
  runtime = pkgs.linkFarm "neovim-runtime" (map (x: { name = "etc/${x.target}"; path = x.source; }) { });

  myConfig = pkgs.vimUtils.buildVimPlugin {
    name = "My Neovim config";
    src = ../lua;
  };
in
rec {
  # Add to finalConficRC
  # require 'lauri'.init()
  finalConfigRC = ''
    lua << EOF
      print "FOO"
    EOF
  '';

  neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = finalConfigRC;

      packages.myVimPackage = {
        start = [
          pkgs.vimPlugins.vim-fugitive
          myConfig
        ];
      };
    };
  };
}
