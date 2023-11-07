{ pkgs, ... }:

{
  vim.startPlugins = with pkgs.vimPlugins; [
    nvim-cmp
    cmp-buffer
    cmp-vsnip
    cmp-path
    cmp-treesitter
  ];

  vim.luaConfigRC = ''
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    local cmp = require'cmp'
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'treesitter' },
        { name = 'path' },
        { name = 'buffer' },
      },
      mapping = {
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c'}),
        ['<C-a>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c'}),
        ['<C-y>'] = cmp.config.disable,
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({
          select = true,
        }),
        ['<C-n>'] = cmp.mapping(function (fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn['vsnip#available'](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-p>'] = cmp.mapping(function (fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn['vsnip#available'](-1) == 1 then
            feedkeys("<Plug>(vsnip-jump-prev)", "")
          end
        end, { 'i', 's' })
      },
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,

          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find "^_+"
            local _, entry2_under = entry2.completion_item.label:find "^_+"
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,

          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    })
  '';
}
