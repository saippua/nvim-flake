{ pkgs, ...}:

{
  vim.startPlugins = with pkgs.vimPlugins; [
    vim-fugitive
    lazygit-nvim
  ];

  vim.nnoremap =
    {
      "<leader>lgg" = "<cmd>LazyGit<CR>";
      "<leader>lg" = "<cmd>LazyGit<CR>";
    };
}
