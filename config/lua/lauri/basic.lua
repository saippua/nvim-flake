local M = {}

M.init = function()
  vim.api.nvim_set_keymap('n', '<space>', '<nop>', { noremap = true, silent = true })

  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
  vim.g.loaded_matchparen = 1

  local opt = vim.opt

  -- Ignore compiled files
  opt.wildignore = "__pycache__"
  opt.wildignore:append { "*.o", "*~", "*.pyc", "*pycache*" }

  opt.showmode = false
  opt.showcmd = true
  opt.cmdheight = 1 -- Height of the command bar
  opt.incsearch = true -- Makes search act like search in modern browsers
  opt.showmatch = true -- show matching brackets when text indicator is over them
  opt.relativenumber = true -- Show line numbers
  opt.number = true -- But show the actual number for the line we're on
  opt.ignorecase = true -- Ignore case when searching...
  opt.smartcase = true -- ... unless there is a capital letter in the query
  opt.hidden = true -- I like having buffers stay around
  opt.equalalways = false -- I don't like my windows changing all the time
  opt.splitright = true -- Prefer windows splitting to the right
  opt.splitbelow = true -- Prefer windows splitting to the bottom
  opt.updatetime = 1000 -- Make updates happen faster
  opt.hlsearch = false -- I wouldn't use this without my DoNoHL function
  opt.scrolloff = 10 -- Make it so there are always ten lines below my cursor
  opt.cursorline = true -- Highlight the current line

  -- Tabs
  opt.autoindent = true
  opt.cindent = true
  opt.wrap = true

  opt.tabstop = 2
  opt.shiftwidth = 2
  opt.softtabstop = 2
  opt.expandtab = true

  opt.breakindent = true
  opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
  opt.linebreak = true

  opt.foldmethod = "marker"
  opt.foldlevel = 0
  opt.modelines = 1

  opt.belloff = "all"

  opt.clipboard = "unnamedplus"

  opt.inccommand = "split"
  opt.swapfile = false
  opt.shada = { "!", "'1000", "<50", "s10", "h" }

  opt.mouse = "a"

  opt.formatoptions = opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2"

  opt.joinspaces = false

  opt.fillchars = { eob = "~" }

  vim.opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }

  vim.opt.undofile = true
  vim.opt.signcolumn = "yes"

  vim.opt.guicursor = nil
end

return M
