{ pkgs, ... }:

{
    vim.startPlugins = with pkgs.vimPlugins; [ harpoon ];

    vim.luaConfigRC = ''
      require"harpoon".setup { }
    '';

    vim.nnoremap =
      {
        "<leader>ws" = "<cmd>lua require'metals'.worksheet_hover()<CR>";
        "<leader>mc" = "<cmd>lua require('telescope').extensions.metals.commands()<CR>";
        "<leader>ha" = "<cmd>lua require('harpoon.mark').add_file()<CR>";
        "<C-e>" =  "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>";
        "<A-u>" = "<cmd>lua require('harpoon.ui').nav_file(1)<CR>";
        "<A-i>" = "<cmd>lua require('harpoon.ui').nav_file(2)<CR>";
        "<A-o>" = "<cmd>lua require('harpoon.ui').nav_file(3)<CR>";
        "<A-p>" = "<cmd>lua require('harpoon.ui').nav_file(4)<CR>";
      };
}
