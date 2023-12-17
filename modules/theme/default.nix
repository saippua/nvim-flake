{ pkgs, ... }:

{
  vim.configRC = ''
    colorscheme onedark
  '';

  vim.startPlugins = with pkgs.vimPlugins; [ onedark-nvim ];

  vim.startLuaConfigRC = ''
    require('onedark').setup {
      style = "darker",
      transparent = "true",
    }
    require('onedark').load()

    vim.cmd("hi Pmenu guibg=#151a1e")
    vim.cmd("hi PmenuSel guifg=#112526 guibg=#ff7400")
    vim.cmd("hi NormalFloat guibg=#151a1e")

    vim.api.nvim_set_hl(0, 'VirtNonText', { fg = "#535965" })
    vim.api.nvim_set_hl(0, 'IblIndent', { fg = "#24272e" })
  '';
}
