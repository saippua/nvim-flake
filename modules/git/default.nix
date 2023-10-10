{ pkgs, ...}:

{
  vim.startPlugins = with pkgs.vimPlugins; [
    vim-fugitive
    lazygit-nvim
  ];

  vim.nnoremap =
    {
      "lg" = "<cmd>LazyGit<CR>";
    };
}
