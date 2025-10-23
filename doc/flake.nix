{
  description = "DevShell for LaTeX + Pygments";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/25.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "latex-shell";
          packages = with pkgs; [
            texliveFull
            python312Packages.pygments
          ];
          shellHook = ''
            export LATEXINDENT_CONFIG=indentconfig.yaml
          '';
        };
      });
}
