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
    vim.g.NERDCreateDefaultMappings = 0
    vim.g.NERDSpaceDelims = 1
    vim.g.NERDDefaultAlign = 'left'
  '';
}
