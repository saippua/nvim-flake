{ ... }:

{
  vim.luaConfigRC = ''
    vim.api.nvim_create_user_command("CommitSearch", function()
      print("test")
    end, {})
  '';
}



