{ pkgs, ... }:

{
  vim.startPlugins = [ pkgs.vimPlugins.trouble-nvim ];

  vim.nnoremap =
    {
      "<leader>tt" = "<cmd> lua require('trouble').toggle('workspace_diagnostics')<CR>";
      "<leader>tp" = "<cmd> lua require('trouble').previous({ skip_groups = true, jump = true })<CR>";
      "<leader>tn" = "<cmd> lua require('trouble').next({ skip_groups = true, jump = true })<CR>";
    };

  vim.luaConfigRC = ''
    require("trouble").setup({
      icons = false
    })
  '';
}
