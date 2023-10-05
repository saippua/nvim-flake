{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
  };

  outputs = inputs @ { nixpkgs, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      packages = forAllSystems (system: 
        let
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = [];
          };
        in
        {
          default = pkgs.neovim;
        }
      );

      overlays.default = final: prev:
        let
        in
        {
        };
    };
}
