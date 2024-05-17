{ pkgs, ... }:

{
  vim.startPlugins = [ pkgs.vimPlugins.indent-blankline-nvim ];

  vim.luaConfigRC = ''
    require("ibl").setup {
        indent = { highlight = "IblIndent", fmt = "nocombine" },
        scope = { enabled = true },
    }
  '';
}
