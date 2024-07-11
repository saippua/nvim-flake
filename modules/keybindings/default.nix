{ pkgs, ... }:

{
  vim.luaConfigRC = /* lua */ ''
    vim.keymap.set('n', '<leader>pv', ":Telescope file_browser path=%:p:h<CR>", {silent = true, noremap = true })
  '';
}
