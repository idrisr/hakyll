{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/25.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        doc = pkgs.callPackage ./doc { };
        compiler = "ghc984";
        mysite =
          pkgs.haskell.packages.${compiler}.callCabal2nix "" ./code/mysite { };
      in
      {
        packages = {
          inherit doc;
          site = pkgs.stdenvNoCC.mkDerivation {
            pname = "mysite-site";
            version = "0.1.0.0";
            src = ./code/mysite;
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
      });
}
