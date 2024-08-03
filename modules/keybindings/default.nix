{ pkgs, ... }:
{
  vim.luaConfigRC = /* lua */ ''
    local opts = { silent = false }

    vim.keymap.set('n', '<leader>pv', ":Telescope file_browser path=%:p:h<CR>", opts)
    vim.keymap.set('n', '<C-S-W><C-S-L>', ":tabnext<CR>", opts)
    vim.keymap.set('n', '<C-S-W><C-S-H>', ":tabprevious<CR>", opts)

    -- Telescope
    local telescope = require('telescope.builtin')
    local file_browser = require("telescope").extensions.file_browser.file_browser

    vim.keymap.set('v', "<leader>ps", require('telescope-live-grep-args.shortcuts').grep_visual_selection, opts);
    vim.keymap.set('n', "<leader>conf", function() file_browser{ path="~/nvim-flake/", select_buffer=true } end, opts);
    vim.keymap.set('n', "<leader>snip", function() file_browser{ path="~/nvim-flake/snippets/", select_buffer=true } end, opts);
    vim.keymap.set('n', "<leader>pf", function() telescope.find_files{ hidden = true } end, opts)
    vim.keymap.set('n', "<leader>ps", telescope.live_grep, opts)
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
        vim.keymap.set('n', "gr", telescope.lsp_references, opts)
        vim.keymap.set('n', "gI", telescope.lsp_implementations, opts)
        vim.keymap.set('n', "gs", telescope.lsp_document_symbols, opts)
        vim.keymap.set('n', "gS", telescope.lsp_workspace_symbols, opts)
        vim.keymap.set('n', "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set('n', "gtd", vim.lsp.buf.definition, opts)
        vim.keymap.set('n', "<leader>dn", vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', "<leader>dp", vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set('n', "<leader>dl", vim.diagnostic.open_float, opts)
        vim.keymap.set('n', "<leader>vf", vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set('n', "<C-S>", vim.lsp.buf.signature_help, opts)

        vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, {});
      end
    })
  '';
}
