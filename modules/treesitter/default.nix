{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];

  vim.configRC = ''
    " Tree-sitter based folding
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
  '';

  vim.luaConfigRC = /* lua */ ''
    -- Treesitter config
    require 'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
        indent = { enable = true },

        incremental_selection = {
            enable = true,
            keymaps = {
                -- Keybindings are defined in the keybindings module
                init_selection = false,
                node_incremental = false,
                scope_incremental = false,
                node_decremental = false,
            },
        },
    }
  '';
}
