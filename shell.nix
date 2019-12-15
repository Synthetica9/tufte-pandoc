{ pkgsHash ? "86ed15dcce7de9c9cac5755663b622142a89d76d" }:

let

  pkgs = import
    (builtins.fetchTarball "https://github.com/nixos/Nixpkgs/archive/${pkgsHash}.tar.gz")
    { config.allowBroken = true; };

in

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
  scons_withPackages = scons_py3.overrideAttrs (old: {
      propagatedBuildInputs = old.propagatedBuildInputs or [] ++
        (with python38Packages; [pyyaml]);
  });
in
mkShell {
  buildInputs = with haskell.packages.ghc881; [
    pandoc_2_9
    latex
    librsvg
    nixpkgs-codebraid.codebraid
    scons_withPackages
    yq
    pandoc-citeproc_0_16_4_1
  ];
}
