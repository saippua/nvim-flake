{ pkgs, lib ? pkgs.lib, ... }:

let
    vimOptions = lib.evalModules {
        modules = [
            { imports = [ ../modules ]; }
        ];
        specialArgs = { inherit pkgs; };
    };

    inherit (vimOptions.config) vim;

    neovim-wrapped = pkgs.wrapNeovim pkgs.neovim {
        configure = {
            customRC = ''
                ${vim.configRC}
                lua <<EOF
                ${vim.startLuaConfigRC}
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

in
{
    neovim = pkgs.symlinkJoin {
        name = "nvim";
        paths = [ neovim-wrapped ] ++ vim.dependencies;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
            wrapProgram $out/bin/nvim \
            --prefix PATH : ${lib.makeBinPath vim.dependencies}
        '';
    };
}
