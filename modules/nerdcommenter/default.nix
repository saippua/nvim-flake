{ pkgs, ...}:

{
  vim.startPlugins = [ pkgs.vimPlugins.nerdcommenter ];

  vim.nnoremap =
    {
      "gcc" = "<Plug>NERDCommenterToggle<CR>";
    };

  vim.vnoremap =
    {
      "gcc" =  "<Plug>NERDCommenterToggle<CR>";
    };

  vim.luaConfigRC = ''
    vim.g.NERDDefaultAlign = 'left'
  '';
}
