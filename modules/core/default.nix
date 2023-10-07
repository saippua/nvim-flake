{ config, lib, ... }:

with lib;
with builtins;

let
  mkMappingOption = it:
    mkOption ({
      default = { };
      type = with types; attrsOf (nullOr str);
    } // it);
in
{
  options.vim = {
    nnoremap = mkMappingOption { description = "Defines 'Normal mode' mappings"; };

    vnoremap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    finalKeybindings = mkOption {
      description = "built Keybindings in vimrc contents";
      type = types.lines;
      internal = true;
      default = "";
    };

    configRC = mkOption {
      description = "vimrc contents";
      type = types.lines;
      default = "";
    };

    luaConfigRC = mkOption {
      description = "vim lua config";
      type = types.lines;
      default = "";
    };

    startPlugins = mkOption {
      description = "List of plugins to startup";
      default = [ ];
      type = with types; listOf (nullOr package);
    };
  };
  config =
    let
      filterNonNull = filterAttrs (name: value: value != null);

      matchCtrl = match "Ctrl-(.)(.*)";

      mapKeyBinding = it:
        let
          groups = matchCtrl it;
        in
        if groups == null
        then it
        else "<C-${toUpper (head groups)}>${head (tail groups)}";

      mapVimBinding = prefix: mappings:
        mapAttrsFlatten (name: value: "${prefix} ${mapKeyBinding name} ${value}")
          (filterNonNull mappings);

      nnoremap = mapVimBinding "nnoremap" config.vim.nnoremap;
      vnoremap = mapVimBinding "vnoremap" config.vim.vnoremap;
    in
      {
      vim.finalKeybindings = ''
        ${builtins.concatStringsSep "\n" nnoremap}
        ${builtins.concatStringsSep "\n" vnoremap}
      '';
    };
}
