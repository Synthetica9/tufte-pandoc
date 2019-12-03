{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  latex = texlive.combine {
    inherit (texlive) scheme-medium
      ifoddpage relsize xifthen ifmtarg datatool xfor substr trimspaces
      cleveref
      tufte-latex hardwrap titlesec
      lipsum;
  };
in
mkShell {
  buildInputs = [
    pandoc
    latex
    yq
    # haskellPackages.pandoc-crossref
  ];
}
