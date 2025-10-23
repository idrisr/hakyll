{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        compiler = "ghc984";
        mysite =
          pkgs.haskell.packages.${compiler}.callCabal2nix "" ./mysite { };
      in
      {
        packages = rec {
          default = site;
          site = pkgs.stdenvNoCC.mkDerivation {
            pname = "mysite-site";
            version = "0.1.0.0";
            src = ./mysite;
            nativeBuildInputs = [ mysite pkgs.coreutils ];
            LANG = "C.UTF-8";
            LC_ALL = "C.UTF-8";
            buildPhase = ''
              cp -r $src .
              runHook preBuild
              ${mysite}/bin/site build
              runHook postBuild
            '';
            installPhase = ''
              runHook preInstall
              mkdir -p "$out"
              cp -r _site/. "$out/"
              runHook postInstall
            '';
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs.haskell.packages."${compiler}"; [
              fourmolu
              cabal-fmt
              implicit-hie
              ghcid
              cabal2nix
              ghc
              cabal-install
              pkgs.ghciwatch
              pkgs.haskell-language-server
              pkgs.haskellPackages.hakyll
              pkgs.zlib
            ];
        };
      }
    );
}
