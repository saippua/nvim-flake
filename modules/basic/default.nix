{ pkgs, ... }:

{
  vim.startPlugins = [
    pkgs.vimPlugins.plenary-nvim
    pkgs.vimPlugins.kwbd
    pkgs.vimPlugins.comment-nvim
  ];

  vim.startLuaConfigRC = /* lua */ ''
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    vim.keymap.set("n", "<space>", "<nop>", { silent = true; noremap = true; })

    vim.opt.clipboard = "unnamedplus"

    vim.opt.nu = true
    vim.opt.rnu = false

    vim.opt.foldmethod = "marker"
    vim.opt.foldlevel = 0
    vim.opt.modelines = 1

    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true

    vim.opt.smartindent = true

    vim.opt.wrap = false

    vim.opt.swapfile = true
    vim.opt.updatetime = 200
    vim.opt.backup = false
    -- vim.opt.undodir = 
    -- vim.opt.undofile = true

    vim.opt.hlsearch = false
    vim.opt.incsearch = true

    vim.opt.signcolumn = 'yes'

    vim.opt.termguicolors = true
    vim.opt.scrolloff = 4

    vim.o.completeopt = 'menu,preview,menuone,noselect'

    vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
      pattern = { "*" },
      callback = function(_)
        vim.bo.formatoptions = vim.bo.formatoptions:gsub("o","").."/"
      end
    })

    vim.api.nvim_create_user_command('SetTab', function(args) 
      vim.opt.tabstop = tonumber(args['args'])
      vim.opt.softtabstop = tonumber(args['args'])
      vim.opt.shiftwidth = tonumber(args['args'])
    end, {nargs=1});


    -- vim.g.vimtext_view_general_viewer = '/mnt/c/Users/Saippua/AppData/Local/SumatraPDF/SumatraPDF.exe' -- WSL ONLY

    -- Disable mouse
    vim.opt.mouse = ""

    -- local is_wsl = (function()
    --   local output = vim.fn.systemlist "uname -r"
    --   return not not string.find(output[1] or "", "WSL")
    -- end)()
    --
    print(string.format("global is %s!", IS_GLOBAL))

    -- if (IS_WSL) then
    --   vim.g.clipboard = {
    --     name = 'win32yank',
    --     copy = {
    --        ["+"] = 'win32yank.exe -i --crlf',
    --        ["*"] = 'win32yank.exe -i --crlf',
    --      },
    --     paste = {
    --        ["+"] = 'win32yank.exe -o --lf',
    --        ["*"] = 'win32yank.exe -o --lf',
    --     },
    --     cache_enabled = 0,
    --   }
    -- end

    vim.opt.ignorecase = true
    vim.opt.smartcase = true
  '';

}
