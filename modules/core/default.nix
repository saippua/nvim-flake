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
  options.lsp = {
    nnoremap = mkMappingOption {
      description = "Defines 'Normal mode' mappings for LSP";
    };
    vnoremap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };
  };
  options.vim = {
    nnoremap = mkMappingOption { 
      description = "Defines 'Normal mode' mappings";
    };

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

    startLuaConfigRC = mkOption {
      description = "start of vim lua config";
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

    dependencies = mkOption {
      description = "List of dependencies for plugins";
      default = [ ];
      type = with types; listOf (nullOr package);
    };
  };
  config =
    let
      filterNonNull = filterAttrs (name: value: value != null);

      mapVimBinding = prefix: mappings:
        mapAttrsFlatten (name: value: "${prefix} ${name} ${value}")
          (filterNonNull mappings);

      nnoremap = mapVimBinding "nnoremap" config.vim.nnoremap;
      vnoremap = mapVimBinding "vnoremap" config.vim.vnoremap;
      lsp_nnoremap = mapVimBinding "nnoremap" config.lsp.nnoremap;
      lsp_vnoremap = mapVimBinding "vnoremap" config.lsp.vnoremap;
    in
      {
      vim.finalKeybindings = ''
        ${builtins.concatStringsSep "\n" nnoremap}
        ${builtins.concatStringsSep "\n" vnoremap}

        ${builtins.concatStringsSep "\n" lsp_nnoremap}
        ${builtins.concatStringsSep "\n" lsp_vnoremap}
      '';
    };
}
