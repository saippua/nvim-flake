{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
  ];

  vim.dependencies = with pkgs; [
    nil # Nix language server
    lua-language-server
    nixpkgs-fmt # Formatter for nixpkgs
    arduino-language-server
    pyright
  ];

  vim.configRC = ''
    autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
  '';

  vim.luaConfigRC = builtins.readFile ./config.lua;
}
