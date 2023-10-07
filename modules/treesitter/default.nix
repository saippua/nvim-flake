{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];

  vim.configRC = ''
    " Tree-sitter based folding
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
  '';

  vim.luaConfigRC =
    ''
      -- Treesitter config
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },

        indent = {
          enable = true,
        },
      }
    '';
}

