{ pkgsHash ? "codebraid-2020-07-01" }:

let
  nixpkgs = builtins.fetchTarball
    "https://github.com/synthetica9/Nixpkgs/archive/${pkgsHash}.tar.gz";
  pkgs = import nixpkgs { config.allowBroken = true; };

in with pkgs;

let
  ourLatex = texlive.combine {
    inherit (texlive)
      scheme-medium
      # Required packages:
      ifoddpage relsize xifthen ifmtarg datatool xfor substr trimspaces cleveref
      tufte-latex hardwrap titlesec semantic catchfile

      # User packages:
      lipsum;
  };

  ourHaskellPackages = haskell.packages.ghc883;

  scons_py_packages = python38Packages;
  scons_py3 = scons.override { python2Packages = scons_py_packages; };
  ourScons = scons_py3.overrideAttrs (old: {
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
    pandoc-citeproc_0_17_0_1
    entr
  ];

  NIX_PATH = "nixpkgs=${nixpkgs}";
}
