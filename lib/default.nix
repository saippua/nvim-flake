{ pkgs, ... }:

let
  myConfig = pkgs.vimUtils.buildVimPlugin {
    name = "My Neovim config";
    src = ../lua;
  };

  # Add to finalConficRC
  # require 'lauri'.init()
  finalConfigRC = ''
    lua << EOF
      print "FOO"
    EOF
  '';
in
rec {
  neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = finalConfigRC;

      packages.myVimPackage = {
        start = with pkgs.vimPlugins; [
          # lsp
          nvim-lspconfig
          nvim-cmp
          cmp-nvim-lsp
          lspkind-nvim

          luasnip
          cmp_luasnip

          nvim-treesitter.withAllGrammars
          nvim-treesitter-context

          nvim-notify
          lualine-nvim
          gitsigns-nvim

          # theme
          catppuccin-nvim

          # telescope
          plenary-nvim
          popup-nvim
          telescope-nvim
          telescope-file-browser-nvim
          telescope-fzf-native-nvim
          tmux-nvim

          vim-nix
          vim-fugitive

          harpoon
          nerdcommenter

          indent-blankline-nvim
          tabular
          wilder-nvim

          myConfig
        ];
      };
    };
  };
}
