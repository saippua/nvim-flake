{ pkgs, ...}:

{
  vim.startPlugins = [ pkgs.vimPlugins.twilight-nvim ];

  vim.nnoremap = {
    "<leader>tw" = "<cmd> Twilight<CR>";
  };
}
