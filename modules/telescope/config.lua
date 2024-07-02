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
      }
    },
    file_ignore_patterns = {
        "node_modules/.*",
	    ".git/.*",
        "flake.lock",
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
      depth=1,
      auto_depth=false,
      hide_parent_dir=false,
      prompt_path=false,
      -- initial_mode = "normal",

      mappings= {
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
