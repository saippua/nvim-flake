{ customPlugins, nightly-overlay, ... }:
final: prev:
let pkgs = (prev.extend nightly-overlay).extend customPlugins;
in
{
  saippua-neovim = (prev.callPackage ./. { inherit pkgs; }).neovim;
}

