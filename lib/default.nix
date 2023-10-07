{ pkgs, lib ? pkgs.lib, ... }:

let
  vimOptions = lib.evalModules {
    modules = [
      { imports = [ ../modules ]; }
    ];

    specialArgs = { inherit pkgs; };
  };

  inherit (vimOptions.config) vim;
in
{
  neovim = pkgs.neovim.override {
    configure = {
      customRC = ''
        lua <<EOF
          ${vim.luaConfigRC}
        EOF

        ${vim.finalKeybindings}
      '';

      packages.myVimPackage = {
        start = vim.startPlugins;
        opt = [];
      };
    };
  };
}
