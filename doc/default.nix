{ stdenvNoCC, texliveFull, python312Packages }:
stdenvNoCC.mkDerivation {
  name = "hakyll";
  pname = "hakyll";
  src = ./src;
  nativeBuildInputs = [ texliveFull python312Packages.pygments ];
  buildPhase = ''
    latexmk 00-main.tex
  '';
  installPhase = ''
    mkdir -p $out
    mv build/00-main.pdf $out/
  '';
}
