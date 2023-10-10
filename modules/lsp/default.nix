{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig  
    cmp-nvim-lsp
    nvim-metals
  ];

  vim.configRC = ''
    autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
  '';

  vim.luaConfigRC = ''
    local lspconfig = require('lspconfig')

    ${builtins.readFile (builtins.toPath ./codelens.lua)}

    local custom_init = function(client)
      client.config.flags = client.config.flags or {}
      client.config.flags.allow_incremental_sync = true
    end

    local attach_keymaps = function(client, bufnr)
      local opts = { noremap=true, silent=true }

      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lr', '<cmd>lua vim.lsp.codelens.run()<CR>', opts)

      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gT', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    
      -- Alternative keybinding for code actions for when code-action-menu does not work as expected.
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true, silent=true, desc = "lsp:hover" })
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'F', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)

      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ds', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', "<cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gI', "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wd', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", opts)

      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    end

    vim.g.formatsave = false

    local format_callback = function(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          if vim.g.formatsave then
              local params = require'vim.lsp.util'.make_formatting_params({})
              client.request('textDocument/formatting', params, nil, bufnr)
          end
        end
      })
    end

    local autocmd = function(args)
      local event = args[1]
      local group = args[2]
      local callback = args[3]

      vim.api.nvim_create_autocmd(event, {
        group = group,
        buffer = args[4],
        callback = function()
          callback()
        end,
        once = args.once,
      })
    end

    local autocmd_clear = vim.api.nvim_clear_autocmds
    local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
    local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
    local augroup_semantic = vim.api.nvim_create_augroup("custom-lsp-semantic", { clear = true })

    local default_on_attach = function(client, bufnr)
      attach_keymaps(client, bufnr)
      format_callback(client, bufnr)

      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

      if client.server_capabilities.documentHighlightProvider then
        autocmd_clear { group = augroup_highlight, buffer = bufnr }
        autocmd { "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight, bufnr }
        autocmd { "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references, bufnr }
      end

      local caps = client.server_capabilities

      if semantic and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
        autocmd_clear { group = augroup_semantic, buffer = bufnr }
      end

      if client.server_capabilities.codeLensProvider then
        autocmd_clear { group = augroup_codelens, buffer = bufnr }
        autocmd { "BufEnter", augroup_codelens, vim.lsp.codelens.refresh, bufnr, once = true }
        autocmd { { "BufWritePost", "CursorHold" }, augroup_codelens, vim.lsp.codelens.refresh, bufnr }
      end
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    capabilities.textDocument.codeLens = { dynamicRegistration = false }
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        },
    }

    if semantic then
      semantic.setup {
        preset = "default",
        highlighters = { require "nvim-semantic-tokens.table-highlighter" },
      }

      semantic.extend_capabilities(updated_capabilities)
    end

    lspconfig.ocamllsp.setup{
      capabilities = capabilities;
      on_init = custom_init;
      on_attach = function(client, bufnr)
        default_on_attach(client, bufnr)

        local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
        autocmd_clear { group = augroup_codelens, buffer = 0 }
        autocmd {
          { "BufEnter", "BufWritePost", "CursorHold" },
          augroup_codelens,
          M.refresh_virtlines,
          0,
        }

        vim.keymap.set(
          "n",
          "<space>vt",
          M.toggle_virtlines,
          { silent = true, desc = "[T]oggle [T]ypes", buffer = 0 }
        )
      end,
      settings = {
        codelens = { enable = true },
      },
      cmd = {"${pkgs.ocaml-ng.ocamlPackages_5_0.ocaml-lsp}/bin/ocamllsp"}
    }

    lspconfig.nil_ls.setup{
      on_init = custom_init;
      capabilities = capabilities;
      on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
      end,
      settings = {
        ['nil'] = {
          formatting = {
            command = {"${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"}
          },
          diagnostics = {
            ignored = { "uri_literal" },
            excludedFiles = { }
          }
        }
      };
      cmd = {"${pkgs.nil}/bin/nil"}
    }

    -- TS config
    lspconfig.tsserver.setup {
      capabilities = capabilities;
      on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
      end,
      cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
    }

    lspconfig.elixirls.setup{
      on_init = custom_init;
      capabilities = capabilities;
      on_attach = default_on_attach;
      cmd = {"${pkgs.elixir-ls}/bin/elixir-ls"}
    }

    -- Python config
    local util = require("lspconfig/util")

    lspconfig.pyright.setup{
      on_init = custom_init;
      capabilities = capabilities;
      on_attach=default_on_attach;
      cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"};

      root_dir = function(fname)
        return util.root_pattern(".git", "setup.py",  "setup.cfg", "pyproject.toml", "requirements.txt")(fname) or util.path.dirname(fname)
      end,

      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true
          },
        },
      },
    }

    local setup_metals = function()
      metals_config = require('metals').bare_config()
      metals_config.capabilities = capabilities
      metals_config.on_attach = function(client, bufnr)
        default_on_attach(client, bufnr)

        local opts = { noremap=true, silent=true }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ws', "<cmd>lua require'metals'.worksheet_hover()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ad', "<cmd>lua require'metals'.open_all_diagnostics()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lmc', '<cmd>lua require("metals").commands()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lmi', '<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>', opts)
      end


      metals_config.settings = {
         metalsBinaryPath = "${pkgs.metals}/bin/metals",
         showImplicitArguments = true,
         showImplicitConversionsAndClasses = true,
         showInferredType = true,
         excludedPackages = {
           "akka.actor.typed.javadsl",
           "com.github.swagger.akka.javadsl"
         }
      }

      metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          virtual_text = {
            prefix = '',
          }
        }
      )

      vim.opt_global.shortmess:remove("F")

      vim.cmd([[augroup lsp]])
      vim.cmd([[autocmd!]])
      vim.cmd([[autocmd FileType java,scala,sbt lua require('metals').initialize_or_attach(metals_config)]])
      vim.cmd([[augroup end]])
    end

    setup_metals()
  '';
}

