{ pkgs, ... }:

{
  vim.startPlugins = [ pkgs.vimPlugins.nvim-spectre ];

  vim.nnoremap =
    {
      "<leader>sr" = "<cmd> lua require('spectre').open_visual({ select_word = true })<CR>";
    };

  vim.luaConfigRC = ''
    require"spectre".setup()
  '';
}
