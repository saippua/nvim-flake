{ pkgs, ...}:

{
  vim.startPlugins = with pkgs.vimPlugins; [
    vim-fugitive
    lazygit-nvim
  ];

  vim.nnoremap =
    {
      "<leader>lg" = "<cmd>LazyGit<CR>";
    };
}
