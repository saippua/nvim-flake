{ pkgs, ... }:
{
  vim.startPlugins = with pkgs.vimPlugins; [
    luasnip
    friendly-snippets
  ];
  # vim.dependencies = with pkgs.python311Packages; [
  #   pynvim
  # ];

  vim.luaConfigRC = /* lua */ ''
    local ls = require('luasnip')
    local from_lua = require('luasnip.loaders.from_lua')
    require('luasnip.loaders.from_vscode').lazy_load()

    -- vim.opt.rtp:append("/home/localadmin/nvim-flake/snippets")
    -- require('luasnip.loaders.from_snipmate').lazy_load()
    from_lua.load({paths = "/home/localadmin/nvim-flake/snippets"})
    ls.config.setup({
      history = false,
      enable_autosnippets = true,
      -- snip_env = 

    })

    
    local in_snip = ls.choice_active()

    local jf = function()
      local jmp = ls.locally_jumpable(1)
      print(jmp)
      if jmp then ls.jump(1) end
    end

    local jb = function()
      local jmp = ls.locally_jumpable(-1)
      print(jmp)
      if jmp then ls.jump(-1) end
    end
    -- vim.keymap.set('i', '<CR>', function() if luasnip.choice_active() then jf else , { remap = false })
    -- vim.keymap.set('s', '<CR>', jf, { remap = false })
    -- vim.keymap.set('i', '<C-p>', jb, { remap = false })
    -- vim.keymap.set('s', '<C-p>', jb, { remap = false })

    vim.api.nvim_create_user_command("Snippets", function() require('luasnip.loaders').edit_snippet_files({}) end, {})

    local i = ls.insert_node
    local t = ls.text_node
    local s = ls.snippet

    ls.add_snippets("lua", {
      s("ternary", {
        i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
      })
    })
  '';
}
