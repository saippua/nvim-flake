{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
  ];

  vim.dependencies = with pkgs; [
    nil # Nix language server
    lua-language-server
    nixpkgs-fmt # Formatter for nixpkgs
    pyright
  ];

  vim.configRC = ''
    autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
  '';

  vim.luaConfigRC = /* lua */
    ''
      local lspconfig = require('lspconfig')
      vim.lsp.set_log_level("ERROR")

      local custom_init = function(client)
          client.config.flags = client.config.flags or {}
          client.config.flags.allow_incremental_sync = true
      end

      local custom_attach = function(client, bufnr)
          vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", })
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
              custom_attach(client, bufnr)
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

      lspconfig.pyright.setup {
        on_init = custom_init;
        capabilities = capabilities;
        on_attach = function(client, bufnr)
          custom_attach(client,bufnr)
        end,
      }

      lspconfig.clangd.setup {
        on_init = custom_init;
        capabilities = capabilities;
        on_attach = function(client, bufnr)
          custom_attach(client, bufnr)
        end,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=bundled",
          -- "--query-driver=/nix/store/*-xtensa-esp32-elf-esp-idf-v5.1.4/bin/xtensa-esp32-elf-*",
        }
      }
    '';
}
