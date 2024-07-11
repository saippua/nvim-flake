{ customPlugins, ... }:
final: prev:
{
  saippua-neovim = (prev.callPackage ./. { inherit customPlugins; }).neovim;
}
