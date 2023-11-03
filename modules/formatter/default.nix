{ pkgs, ...}:

let
  prettier = "${pkgs.nodePackages.prettier}/bin/prettier";
in
{
  vim.startPlugins = with pkgs.vimPlugins; [
    formatter-nvim
  ];

  vim.luaConfigRC = ''
    local util = require "formatter.util"
    require("formatter").setup {
      filetype = {
        typescript = { 
          function() 
            return {
              exe = "${prettier}",
              args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
              stdin = true
            }
          end 
        },
        typescriptreact = { 
          function() 
            return {
              exe = "${prettier}",
              args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
              stdin = true
            }
          end 
        },
        javascript = { 
          function() 
            return {
              exe = "${prettier}",
              args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
              stdin = true
            }
          end 
        },
        javascriptreact = { 
          function() 
            return {
              exe = "${prettier}",
              args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
              stdin = true
            }
          end 
        },
        json = { 
          function() 
            return {
              exe = "${prettier}",
              args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
              stdin = true
            }
          end 
        }
      }
    }
  '';


  vim.nnoremap =
    {
      "<leader>fmt" = "<cmd>FormatWrite<CR>";
    };
}

