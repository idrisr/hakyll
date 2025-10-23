{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/25.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        doc = pkgs.callPackage ./doc { };
      in
      {
        packages = {
          default = doc;
          inherit doc;
        };
      });
}
