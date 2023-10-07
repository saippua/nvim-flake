{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    popup-nvim
    telescope-nvim
    telescope-file-browser-nvim
    telescope-fzf-native-nvim
  ];

  vim.luaConfigRC = ''
    function get_vsel()
      vim.cmd('noau normal! "vy"')
      local text = vim.fn.getreg('v')
      vim.fn.setreg('v', {})

      text = string.gsub(text, "\n", "")
      local result = require("telescope.builtin").grep_string { search = text }

      return result
    end

    require("telescope").setup {
      defaults = {
        file_ignore_patterns = {
            "node_modules/.*",
        },
        vimgrep_arguments = {
          "${pkgs.ripgrep}/bin/rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case"
        },
        pickers = {
          find_command = {
            "${pkgs.fd}/bin/fd --strip-cwd-prefix --type f",
          },
        },

        extensions = {
          fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true,
          },

          fzf_writer = {
            use_highlighter = false,
            minimum_grep_characters = 6,
          },
        },
      },
    }

    require("telescope").load_extension("file_browser")
    require("telescope").load_extension("fzf")
  '';

  vim.nnoremap =
    {
      "<leader>fg" = "<cmd> lua require('telescope.builtin').git_files{ }<CR>";
      "<leader>ff" = "<cmd> lua require('telescope.builtin').find_files{ hidden = true }<CR>";
      "<leader>fl" = "<cmd> lua require('telescope.builtin').live_grep()<CR>";
      "<leader>fb" = "<cmd> lua require('telescope.builtin').buffers()<CR>";
      "<leader>fh" = "<cmd> lua require('telescope.builtin').help_tags()<CR>";
      "<leader>fd" = "<cmd> lua require('telescope.builtin').diagnostics()<CR>";
      "<leader>fr" = "<cmd> lua require('telescope.builtin').registers()<CR>";
      "<leader>fo" = "<cmd> lua require('telescope.builtin').oldfiles()<CR>";
      "<leader>rs" = "<cmd> lua require('telescope.builtin').resume()<CR>";
      "<leader>fe" = "<cmd> Telescope file_browser path=%:p:h select_buffer=true<CR>";

      "<leader>tlsb" = "<cmd> Telescope lsp_document_symbols<CR>";
      "<leader>tlsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

      "<leader>tlr" = "<cmd> Telescope lsp_references<CR>";
      "<leader>tli" = "<cmd> Telescope lsp_implementations<CR>";
      "<leader>tlD" = "<cmd> Telescope lsp_definitions<CR>";
      "<leader>tlt" = "<cmd> Telescope lsp_type_definitions<CR>";
      "<leader>tld" = "<cmd> Telescope diagnostics<CR>";
    };

  vim.vnoremap =
    {
      "<leader>fv" = "<cmd> lua get_vsel()<CR>";
    };
}
