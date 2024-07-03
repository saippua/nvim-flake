{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-24.05;
  };

  outputs = inputs @ { nixpkgs, ... }:
    let
      system = "x86_64-linux";

      customPlugins = import ./lib/customPlugins.nix;
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          customPlugins
        ];
      };
      neovim = (import ./lib { inherit pkgs; }).neovim;
    in
    {
      packages.${system}.default = neovim;
      overlays.default = import ./lib/overlay.nix;
    };
}
