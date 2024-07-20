{ pkgs, ... }:
{
  vim.luaConfigRC = /* lua */ ''
    vim.keymap.set('n', '<leader>pv', ":Telescope file_browser path=%:p:h<CR>", {silent = true, noremap = true })
    vim.keymap.set('n', '<C-S-W><C-S-L>', ":tabnext<CR>", {silent = true, noremap = true })
    vim.keymap.set('n', '<C-S-W><C-S-H>', ":tabprevious<CR>", {silent = true, noremap = true })
  '';
}
