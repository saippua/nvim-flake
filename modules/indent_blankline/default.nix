{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [
    indent-blankline-nvim
  ];

  vim.luaConfigRC = /* lua */ ''

    local ibl_highlight = {
        "iblHL1",
        "iblHL2",
        "iblHL3",
        "iblHL4",
        "iblHL5",
        "iblHL6",
    }
    local ibl_hooks = require('ibl.hooks')
    ibl_hooks.register(ibl_hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "iblHL1", { fg = "#264a49" })
        vim.api.nvim_set_hl(0, "iblHL2", { fg = "#314a26" })
        vim.api.nvim_set_hl(0, "iblHL3", { fg = "#4a4811" })
        vim.api.nvim_set_hl(0, "iblHL4", { fg = "#4a2b26" })
        vim.api.nvim_set_hl(0, "iblHL5", { fg = "#43264a" })
        vim.api.nvim_set_hl(0, "iblHL6", { fg = "#2c2a69" })
    end)

    local ibl = require('ibl')
    ibl.setup {
      -- exclude = { filetypes = { 'nix' } },
      scope = {
        enabled = false,
        -- show_start = false,
        -- show_end = false,
      },
      indent = {
        highlight = ibl_highlight,
		    char = "▏", -- This is a slightly thinner char than the default one, check :help ibl.config.indent.char
      },
    }
  '';
}
