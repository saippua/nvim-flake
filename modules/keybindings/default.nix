{ pkgs, ... }:
{
  vim.luaConfigRC = /* lua */ ''
    vim.keymap.set('n', '<leader>pv', ":Telescope file_browser path=%:p:h<CR>", {silent = true, noremap = true })
    vim.keymap.set('n', '<C-L>', ":tabnext", {silent = true, noremap = true })
    vim.keymap.set('n', '<C-H>', ":tabprevious", {silent = true, noremap = true })
  '';
}
