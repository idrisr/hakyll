{ pkgs, ... }:
let compiler = "ghc965";
in {
  packages = with pkgs.haskell.packages."${compiler}"; [
    fourmolu
    cabal-fmt
    pkgs.git
  ];

  languages.haskell = { enable = true; };

  scripts = {
    rebuild = {
      exec = ''
        cd $DEVENV_ROOT/notes
        cabal run site -- rebuild
      '';
      description = "rebuild site";
    };

    serve = {
      exec = ''
        cd $DEVENV_ROOT/notes
        cabal run site -- server
      '';
      description = "serve site";
    };
  };
}
