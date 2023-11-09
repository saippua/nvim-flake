{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    popup-nvim
    telescope-nvim
    telescope-file-browser-nvim
    telescope-fzf-native-nvim
    telescope-live-grep-args-nvim
  ];

  vim.luaConfigRC = ''
    local telescope = require("telescope")
		telescope.setup({
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

				live_grep_args = {
					auto_quoting = false, 
					mappings = { -- extend mappings
						i = {
							["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
              ["<C-g>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " })
						},
					},
				},
			},
		})

		telescope.load_extension("live_grep_args")
    telescope.load_extension("file_browser")
    telescope.load_extension("fzf")
  '';

  vim.nnoremap =
    {
      "<leader>fg" = "<cmd> lua require('telescope.builtin').git_files{ }<CR>";
      "<leader>ff" = "<cmd> lua require('telescope.builtin').find_files{ hidden = true }<CR>";
      "<leader>fl" = "<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>";
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
      "<leader>fv" = "<cmd> lua require('telescope-live-grep-args.shortcuts').grep_visual_selection()<CR>";
    };
}
