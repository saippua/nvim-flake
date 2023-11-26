{ pkgs, ... }:

{
  vim.startPlugins = [ pkgs.vimPlugins.git-worktree-nvim ];

  vim.luaConfigRC = ''
    require("git-worktree").setup()
  '';
}
