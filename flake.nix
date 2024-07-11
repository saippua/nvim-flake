{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, ... }:
    let
      system = "x86_64-linux";

      customPlugins = import ./lib/customPlugins.nix;
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          inputs.neovim-nightly-overlay.overlays.default
          customPlugins
        ];
      };
      neovim = (import ./lib { inherit pkgs; }).neovim;
    in
    {
      packages.${system}.default = neovim;
      overlays.default = (import ./lib/overlay.nix {
        inherit customPlugins;
        nightly-overlay = inputs.neovim-nightly-overlay.overlays.default;
        });
    };
}
