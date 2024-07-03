local lspconfig = require('lspconfig')

local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

local attach_keymaps = function(client, bufnr)
    local opts = { noremap=true, silent=true }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", })

    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lr', '<cmd>lua vim.lsp.codelens.run()<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gtd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true, silent=true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-S>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>dl', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', "<cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gI', "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wd', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>vf', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

    vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, {});
end

-- Update LSP capabilities from cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())



-- Extend completion sources with nvim_lsp
local cmp = require('cmp');
local config = cmp.get_config()
table.insert(config.sources, { name = 'nvim_lsp', })
table.insert(config.sources, { name = 'nvim_lsp_signature_help', })
cmp.setup(config)

lspconfig.nil_ls.setup {
    on_init = custom_init;
    capabilities = capabilities;
    on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
    end,
    settings = {
        ['nil'] = {
            formatting = {
                command = {"nixpkgs-fmt"}
            },
            diagnostics = {
                ignored = { "uri_literal" },
                excludedFiles = { }
            }
        }
    };
    cmd = {"nil"}
}

lspconfig.lua_ls.setup {
    on_init = custom_init;
    capabilities = capabilities;
    on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
    end,
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    'vim',
                },
            },
            completion = {
                workspaceWord = false,
                showWord = "Disable",
            },
        },
    }
}

lspconfig.arduino_language_server.setup {
    on_init = custom_init;
    -- Disable semantic tokens for arduino LSP
    capabilities = vim.tbl_deep_extend("force", capabilities,
        {
            TextDocument = { semanticTokens = vim.NIL, },
            workspace = { semanticTokens = vim.NIL, },
        }),
    on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
    end,
    settings = {
    },
    cmd = {
        'arduino-language-server',
        '-clangd', 'clangd',
        '-cli', 'arduino-cli',
        '-cli-config', '/home/localadmin/.arduino15/arduino-cli.yaml',
        '-fqbn', 'esp32:esp32:esp32',
        '-log',
    }
}

