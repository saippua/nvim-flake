{ pkgs, ... }:
{
  vim.luaConfigRC = /* lua */ ''
    local opts = { silent = false }

    vim.keymap.set('v', 'd', '"_d', opts) -- Deleting doesn't override yank
    vim.keymap.set('n', 'dd', '"_dd', opts) -- Deleting doesn't override yank
    vim.keymap.set('v', 'c', '"_c', opts) -- Changing doesn't override yank
    vim.keymap.set('v', 'p', '"+P', opts) -- Pasting doesn't override yank
    vim.keymap.set('v', 'P', '"+P', opts) -- Pasting doesn't override yank
    vim.keymap.set({'n', 'v'}, 'y', '"+y', opts) -- Yank to system clipboard
    vim.keymap.set({'n', 'v'}, 'Y', '"+Y', opts) -- Yank to system clipboard
    vim.keymap.set({'n', 'v'}, 'x', '"+x', opts) -- Cut to system clipboard
    vim.keymap.set({'n', 'v'}, 'X', '"+X', opts) -- Cut to system clipboard
    vim.keymap.set('n', 'p', '"+p', opts) -- Paste from system clipboard
    vim.keymap.set('n', 'P', '"+P', opts) -- Paste from system clipboard

    vim.keymap.set('n', '<leader>pv', ":Telescope file_browser path=%:p:h<CR>", opts)
    vim.keymap.set('n', '<C-S-W><C-S-L>', ":tabnext<CR>", opts)
    vim.keymap.set('n', '<C-S-W><C-S-H>', ":tabprevious<CR>", opts)

    -- Telescope
    local telescope = require('telescope.builtin')
    local telescope_rg = require('telescope-live-grep-args.shortcuts')
    local lga_actions = require('telescope-live-grep-args.actions')
    local file_browser = require("telescope").extensions.file_browser.file_browser
    local live_grep_args = require('telescope').extensions.live_grep_args

    local vga = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",

      "--no-ignore" 
    }

    vim.keymap.set('v', "<leader>ps", function() telescope_rg.grep_visual_selection() end, opts);
    vim.keymap.set('v', "<leader>pS", function() telescope_rg.grep_visual_selection{ vimgrep_arguments = vga, } end, opts);
    vim.keymap.set('n', "<leader>conf", function() file_browser{ path="~/nvim-flake/", select_buffer=true } end, opts);
    vim.keymap.set('n', "<leader>snip", function() file_browser{ path="~/nvim-flake/snippets/", select_buffer=true } end, opts);
    vim.keymap.set('n', "<leader>pf", function() telescope.find_files{ hidden = true } end, opts)
    vim.keymap.set('n', "<leader>pF", function() telescope.find_files{ hidden = true, no_ignore = true } end, opts)
    vim.keymap.set('n', "<leader>ps", function() live_grep_args.live_grep_args() end, opts)
    vim.keymap.set('n', "<leader>pS", function() live_grep_args.live_grep_args({
      vimgrep_arguments = vga,
      -- -- Doesn't work for some reason (maybe outdated plugin)
      -- additional_args = {
      --   "--no-ignore"
      -- }
    }) end, opts)
    vim.keymap.set('n', "<leader>pg", telescope.git_files, opts)
    vim.keymap.set('n', "<leader>va", telescope.diagnostics, opts)
    vim.keymap.set('n', "<leader>pq", telescope.quickfix, opts)
    vim.keymap.set('n', "<leader>pb", telescope.buffers, opts)


    -- Calling incremental selection functions directly can cause errors when the function is used incorrectly
    -- e.g. on an empty file. We wrap the call in a `pcall` to swallow the errors.
    local incremental_selection = require('nvim-treesitter.incremental_selection')
    vim.keymap.set('n', "<CR>", function() pcall(incremental_selection.init_selection) end, { silent = true })
    vim.keymap.set('v', "<CR>", function() pcall(incremental_selection.node_incremental) end, { silent = true })
    vim.keymap.set('v', "<S-CR>", function() pcall(incremental_selection.node_decremental) end, { silent = true })


    -- Language Server
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = false }

        client_name = function(id)
          return vim.lsp.get_client_by_id(id).name
        end

        if client_name(ev.data.client_id) == "clangd" then
          vim.keymap.set('n', "<leader>h", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
        end

        -- Telescope
        vim.keymap.set('n', '<leader>wd', telescope.lsp_document_symbols, opts)
        vim.keymap.set('n', "grn", vim.lsp.buf.rename, opts)
        vim.keymap.set('n', "grr", telescope.lsp_references, opts)
        vim.keymap.set('n', "gra", vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', "grd", telescope.lsp_definitions, opts)
        vim.keymap.set('n', "gd", telescope.lsp_definitions, opts)
        vim.keymap.set('n', "grI", telescope.lsp_implementations, opts)
        vim.keymap.set('n', "grs", telescope.lsp_document_symbols, opts)
        vim.keymap.set('n', "grS", telescope.lsp_workspace_symbols, opts)
        vim.keymap.set('n', "grD", vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', "<leader>dn", vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', "<leader>dp", vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', "<leader>dl", vim.diagnostic.open_float, opts)
        vim.keymap.set('n', "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set('n', "<C-S>", vim.lsp.buf.signature_help, opts)

        vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, {});
      end
    })
  '';
}
