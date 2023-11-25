{ pkgs, ... }:

let
  statePath = "~/.local/share/mind.nvim/mind.json";
  dataDir = "~/.local/share/mind.nvim/data";
in
{
  vim.startPlugins = [ pkgs.vimPlugins.mind-nvim ];

  vim.nnoremap = {
    "<leader>mo" = "<cmd> MindOpenMain<CR>";
    "<leader>mc" = "<cmd> MindClose<CR>";
  };

  vim.luaConfigRC = ''
    require('mind').setup({
      persistence = {
        state_path = "${statePath}",
        data_dir = "${dataDir}"
      },
      tree = {
        automatic_creation = true,
        automatic_data_creation = true
      },
      ui = {
        url_open = "${pkgs.xdg-utils}/bin/xdg-open",
        width = 40,
        select_marker = "",
        local_marker = "",
        data_marker = "",
        icon_preset = {
          { ' ', 'Sub-project' },
          { ' ', 'For when you have an idea' },
          { ' ', 'Note taking?' },
          { '', 'Full square or on-going' },
          { '󰄲 ', 'Check or done' },
          { ' ', 'Trash bin, deleted, cancelled, etc.' },
        };
      }
    })
  '';
}
