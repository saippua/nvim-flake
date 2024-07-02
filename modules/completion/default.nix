{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [
    nvim-cmp
    cmp-cmdline
    cmp-buffer
    cmp-path
    cmp-nvim-lua
    # cmp-luasnip

    # cmp-nvim-lsp-signature-help
  ];

  vim.luaConfigRC = builtins.readFile ./config.lua;
}
