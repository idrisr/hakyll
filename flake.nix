{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      system = flake-utils.lib.system.x86_64-linux;
      compiler = "ghc965";
      renameme =
        pkgs.haskell.packages.${compiler}.callCabal2nix "" ./renameme { };

    in { packages.${system}.default = renameme; };
}
