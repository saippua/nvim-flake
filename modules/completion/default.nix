{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [
    nvim-cmp
    cmp-cmdline
    cmp-buffer
    cmp-path
    cmp-nvim-lua
    cmp_luasnip
    # cmp-nvim-lsp-signature-help
  ];

  vim.luaConfigRC = /* lua */ ''
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
            documentation = cmp.config.window.bordered(),
        },


        mapping = {
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = {
                i = cmp.mapping.abort(),
                c = cmp.mapping.abort(),
            },
            ['<CR>'] = cmp.mapping({
              i = function(fb) if luasnip.locally_jumpable(1) then luasnip.jump(1) else if cmp.visible() and cmp.get_active_entry() then cmp.confirm({ select = false }) else fb() end end end,
              s = function(fb) if luasnip.locally_jumpable(1) then luasnip.jump(1) else fb() end end,
            }),
            ['C-n'] = cmp.mapping({
              i = function(fb) if luasnip.locally_jumpable(1) then luasnip.jump(1) else fb() end end,
              s = function(fb) if luasnip.locally_jumpable(1) then luasnip.jump(1) else fb() end end,
            }),
            ['C-p'] = cmp.mapping({
              i = function(fb) if luasnip.locally_jumpable(-1) then luasnip.jump(-1) else fb() end end,
              s = function(fb) if luasnip.locally_jumpable(-1) then luasnip.jump(-1) else fb() end end,
            }),
            ['<Tab>'] = cmp.mapping({
                i = function(fb) if cmp.visible() then cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert }) else fb() end end,
                c = function()
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                    else
                        cmp
                            .complete()
                    end
                end,
            }),
            ['<S-Tab>'] = cmp.mapping({
                i = function(fb) if cmp.visible() then cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) else fb() end end,
                c = function()
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                    else
                        cmp
                            .complete()
                    end
                end,
            }),
        },

        sources = {
            { name = 'luasnip' },
            -- { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            -- { name = 'nvim_lsp_signature_help' },
            { name = 'path' },
            -- { name = 'buffer' },
        },
    }

    cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
            {
                name = 'path',
                option = {
                    trailing_slash = true,
                }
            }
        }, {
            {
                name = 'cmdline',
                keyword_length = 2,
            }
        }),
        matching = {
            disallow_fuzzy_matching = true,
            disallow_partial_matching = true,
        },
    })

  '';
}
