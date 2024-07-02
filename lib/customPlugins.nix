final: prev:

let
  buildPlugin = prev.vimUtils.buildVimPlugin;
in
{
  vimPlugins = prev.vimPlugins //
  {
      kwbd = buildPlugin {
          name = "Kwbd";
          src = final.fetchFromGitHub {
              owner = "rgarver";
              repo = "Kwbd.vim";
              rev = "master";
              sha256 = "hj/8LBOkehaP1y3wFdcwHl+n9BkFp2bI+kkKj5B9jzI=";
          };
      };
  };
}
