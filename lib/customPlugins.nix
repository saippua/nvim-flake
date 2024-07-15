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
      vim-arduino = buildPlugin {
        name = "vim-arduino";
        src = final.fetchFromGitHub {
          owner = "stevearc";
          repo = "vim-arduino";
          rev = "master";
          sha256 = "sha256-+aIIg6VebT06VUKpXo2p9ykFzxGW+WspjxwR6FqouYE=";
        };
      };
    };
}
