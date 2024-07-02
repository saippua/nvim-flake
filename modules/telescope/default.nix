{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    popup-nvim
    telescope-nvim
    telescope-file-browser-nvim
    # telescope-fzf-native-nvim
    telescope-live-grep-args-nvim
    # advanced-git-search
  ];

  vim.dependencies = with pkgs; [
    ripgrep
    fd
  ];


  vim.luaConfigRC = builtins.readFile ./config.lua;

  vim.nnoremap =
    {
        "<leader>pv" 	= ":Telescope file_browser path=%:p:h<CR>";
        "<leader>conf" 	= ":Telescope file_browser path=~/.config/nvim/ select_buffer=true<CR>";
        "<leader>pf" 	= "<cmd> lua require('telescope.builtin').find_files{ hidden = true }<CR>";
        "<leader>ps" 	= "<cmd> lua require('telescope.builtin').live_grep{ }<CR>";
        "<leader>pg" 	= "<cmd> lua require('telescope.builtin').git_files{ }<CR>";
        "<leader>va" 	= "<cmd> lua require('telescope.builtin').diagnostics{ }<CR>";
        "<leader>pq" 	= "<cmd> lua require('telescope.builtin').quickfix{ }<CR>";
        "<leader>pb"	= "<cmd> lua require('telescope.builtin').buffers{ }<CR>";

        "gr" 		    = "<cmd> lua require('telescope.builtin').lsp_references{ }<CR>";
        "gs"		    = "<cmd> lua require('telescope.builtin').lsp_document_symbols{ }<CR>";
        "gS"	        = "<cmd> lua require('telescope.builtin').lsp_workspace_symbols{ }<CR>";
    };

  vim.vnoremap =
    {
        "<leader>ps" = "<cmd> lua require('telescope-live-grep-args.shortcuts').grep_visual_selection()<CR>";
    };
}

