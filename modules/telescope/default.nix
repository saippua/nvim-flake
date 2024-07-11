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
# These are defined system wide, so they are disabled here to prevent collisions
    # ripgrep
    # fd
  ];


  vim.luaConfigRC = /* lua */ ''
    local builtin = require('telescope.builtin')
    local telescope = require('telescope')
    local fb_actions = require "telescope._extensions.file_browser.actions"


    telescope.setup {
      defaults = {
          mappings = {
              i = {
                  ["<C-h>"] = "which_key",
                  ["<C-j>"] = "move_selection_next",
                  ["<C-k>"] = "move_selection_previous",
              },
          },
          file_ignore_patterns = {
              "node_modules/.*",
              ".git/.*",
              "flake.lock",
              "mlruns/.*",
              "__pycache__/.*",
          },
          vimgrep_arguments = {
              "rg",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
          },
          pickers = {
              find_command = {
                  "fd --strip-cwd-prefix --type f",
              },
          },

      },
      extensions = {
          file_browser = {
              theme = "ivy",
              hijack_netrw = true,
              depth = 1,
              auto_depth = false,
              hide_parent_dir = false,
              prompt_path = false,
              -- initial_mode = "normal",

              mappings = {
                  ["i"] = {
                      ["<M-c>"] = false, -- unmap create
                  },
                  ["n"] = {
                      ["g"] = false,
                      ["<BS>"] = fb_actions.backspace,
                      ["c"] = false,
                      ["%"] = fb_actions.create,
                  }
              }
          }
      }
    }


    telescope.load_extension 'file_browser'
  '';

  vim.nnoremap =
    {
      # "<leader>pv"  = ":Telescope file_browser path=%:p:h<CR>";
      "<leader>conf" = ":Telescope file_browser path=~/nvim-flake/ select_buffer=true<CR>";
      "<leader>snip" = ":Telescope file_browser path=~/nvim-flake/snippets/ select_buffer=true<CR>";
      "<leader>pf" = "<cmd> lua require('telescope.builtin').find_files{ hidden = true }<CR>";
      "<leader>ps" = "<cmd> lua require('telescope.builtin').live_grep{ }<CR>";
      "<leader>pg" = "<cmd> lua require('telescope.builtin').git_files{ }<CR>";
      "<leader>va" = "<cmd> lua require('telescope.builtin').diagnostics{ }<CR>";
      "<leader>pq" = "<cmd> lua require('telescope.builtin').quickfix{ }<CR>";
      "<leader>pb" = "<cmd> lua require('telescope.builtin').buffers{ }<CR>";
    };

  vim.vnoremap =
    {
      "<leader>ps" = "<cmd> lua require('telescope-live-grep-args.shortcuts').grep_visual_selection()<CR>";
    };

  lsp.nnoremap = {
    "gr" = "<cmd>lua require('telescope.builtin').lsp_references()<CR>";
    "gI" = "<cmd>lua require('telescope.builtin').lsp_implemenation()<CR>";
    "gs" = "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>";
    "gS" = "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>";

    "gD" = "<cmd>lua vim.lsp.buf.declaration()<CR>";
    "gd" = "<cmd>lua vim.lsp.buf.definition()<CR>";
    "gtd" = "<cmd>lua vim.lsp.buf.definition()<CR>";
    "<leader>dn" = "<cmd>lua vim.diagnostic.goto_next()<CR>";
    "<leader>dp" = "<cmd>lua vim.diagnostic.goto_prev()<CR>";

    "K" = "<cmd>lua vim.lsp.buf.hover()<CR>";
    "<C-S>" = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
    "<leader>rn" = "<cmd>lua vim.lsp.buf.rename()<CR>";

    "<leader>dl" = "<cmd>lua vim.diagnostic.open_float()<CR>";

    "<leader>vf" = "<cmd>lua vim.lsp.buf.code_action()<CR>";
    "<leader>vd" = "<cmd>lua vim.diagnostic.open_float()<CR>";
  };
}

