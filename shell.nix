{ pkgsHash ? "0c960262d159d3a884dadc3d4e4b131557dad116" }:

let
  nixpkgs = builtins.fetchTarball "https://github.com/nixos/Nixpkgs/archive/${pkgsHash}.tar.gz";
  pkgs = import nixpkgs { config.allowBroken = true; };

in

with pkgs;

let
  nixpkgs-codebraid = import (builtins.fetchTarball "https://github.com/synthetica9/Nixpkgs/archive/codebraid-init.tar.gz") {};

  latex = texlive.combine {
    inherit (texlive) scheme-medium
      # Required packages:
      ifoddpage relsize xifthen ifmtarg datatool xfor substr trimspaces
      cleveref
      tufte-latex hardwrap titlesec semantic

      # User packages:
      lipsum;
  };

  ourHaskellPackages = haskell.packages.ghc882;
  ourPandoc = ourHaskellPackages.pandoc_2_9_1_1;

  codebraid = nixpkgs-codebraid.override {
    pandoc = ourPandoc;
  };

  scons_py_packages = python38Packages;
  scons_py3 = scons.override { python2Packages = scons_py_packages; };
  scons_withPackages = scons_py3.overrideAttrs (old: {
      propagatedBuildInputs = old.propagatedBuildInputs or [] ++
        (with scons_py_packages; [ pyyaml requests ]);
  });
in
mkShell {
  buildInputs = with ourHaskellPackages; [
    nixpkgs-codebraid.codebraid
    latex
    librsvg
    ourPandoc
    pandoc-citeproc_0_16_4_1
    scons_withPackages
  ];

  NIX_PATH = "nixpkgs=${nixpkgs}";
}
