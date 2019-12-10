{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  nixpkgs-codebraid = import (builtins.fetchTarball "https://github.com/synthetica9/Nixpkgs/archive/codebraid-init.tar.gz") {};

  latex = texlive.combine {
    inherit (texlive) scheme-medium
      # Required packages:
      ifoddpage relsize xifthen ifmtarg datatool xfor substr trimspaces
      cleveref
      tufte-latex hardwrap titlesec

      # User packages:
      lipsum;
  };

  scons_py3 = scons.override { python2Packages = python38Packages; };
in
mkShell {
  buildInputs = [
    pandoc
    latex
    yq
    scons_py3
    nixpkgs-codebraid.codebraid
  ];
}
