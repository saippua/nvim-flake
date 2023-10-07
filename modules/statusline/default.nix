{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [ lualine-nvim ];
  vim.luaConfigRC = ''
    require"lualine".setup {
      options = {
        icons_enabled = true,
        component_separators = { left = '|', right = '|' },
        extensions = { "fzf", "quickfix" },
        icons_enabled = false,
        section_separators = { left = "", right = "" },
        --theme = custom_catppuccin
        theme = "auto",
      },
    }
  '';
}
