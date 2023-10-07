{ pkgs, ...}:

{
  vim.startPlugins = [ pkgs.vimPlugins.wilder-nvim ];
  vim.luaConfigRC = ''
    local wilder = require"wilder"
    wilder.setup({
      modes        = {':', '/', '?'},
      next_key     = '<C-n>',
      previous_key = '<C-p>',
      accept_key   = '<Tab>',
      reject_key   = '<S-Tab>',
    })

    wilder.set_option('renderer', wilder.popupmenu_renderer({
      -- highlighter applies highlighting to the candidates
      highlighter = wilder.basic_highlighter(),
    }))
  '';
}
