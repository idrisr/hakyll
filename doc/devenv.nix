{ pkgs, ... }: {
  packages = [ pkgs.codespell pkgs.python312Packages.pygments ];

  env.LATEXINDENT_CONFIG = "indentconfig.yaml";
  languages.texlive = {
    enable = true;
    base = pkgs.texliveFull;
  };

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
