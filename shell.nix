{ pkgsHash ? "999abcfc07286f9d2f88fbe31954df5cfd98db87" }:

let
  nixpkgs = builtins.fetchTarball
    "https://github.com/NixOS/Nixpkgs/archive/${pkgsHash}.tar.gz";
  pkgs = import nixpkgs { config.allowBroken = true; };

in with pkgs;

let
  ourLatex = texlive.combine {
    inherit (texlive)
      scheme-medium
      # Required packages:
      ifoddpage relsize xifthen ifmtarg datatool xfor substr trimspaces cleveref
      tufte-latex hardwrap titlesec semantic catchfile framed

      # User packages:
      lipsum;
  };

  ourHaskellPackages = haskell.packages.ghc883;

  scons_py_packages = python38Packages;
  ourScons = scons.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs or [ ]
      ++ (with scons_py_packages; [ pyyaml requests ]);
  });
in mkShell {
  buildInputs = with ourHaskellPackages; [
    ourLatex
    ourScons

    pandoc
    codebraid
    librsvg
    pandoc-citeproc
    entr
  ];

  NIX_PATH = "nixpkgs=${nixpkgs}";
}
