{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [ lspkind-nvim ];

  vim.luaConfigRC = ''
    require'lspkind'.init()
  '';
}
