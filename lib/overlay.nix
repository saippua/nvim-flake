{ pkgs }:
final: prev:
{
  saippua-neovim = (prev.callPackage ./. { inherit pkgs; }).neovim;
}
