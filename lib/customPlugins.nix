final: prev:

let
  buildPlugin = prev.vimUtils.buildVimPlugin;
in
{
  vimPlugins = prev.vimPlugins //
  {
    advanced-git-search = buildPlugin {
      name = "advanced-git-search";
      src = final.fetchFromGitHub {
        owner = "aaronhallaert";
        repo = "advanced-git-search.nvim";
        rev = "5637d80";
        sha256 = "RPUXNn6oyZ/32o5MyMP+gXAUe6y/S5+JsiPFu0nI3Vo=";
      };
    };
  };
}
