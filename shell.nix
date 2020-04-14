{ pkgsHash ? "d363be93b4957fce418a00340edc8b9bad5a1c88" }:

let
  nixpkgs = builtins.fetchTarball
    "https://github.com/nixos/Nixpkgs/archive/${pkgsHash}.tar.gz";
  pkgs = import nixpkgs { config.allowBroken = true; };

in with pkgs;

let
  ourLatex = texlive.combine {
    inherit (texlive)
      scheme-medium
      # Required packages:
      ifoddpage relsize xifthen ifmtarg datatool xfor substr trimspaces cleveref
      tufte-latex hardwrap titlesec semantic

      # User packages:
      lipsum;
  };

  ourHaskellPackages = haskell.packages.ghc881;
  ourPandoc = ourHaskellPackages.pandoc_2_9_1_1.overrideAttrs (old: {
    # 2020-02-25: currently pandoc tests are failing.
    doCheck = false;
  });

  scons_py_packages = python38Packages;
  scons_py3 = scons.override { python2Packages = scons_py_packages; };
  ourScons = scons_py3.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs or [ ]
      ++ (with scons_py_packages; [ pyyaml requests ]);
  });
in mkShell {
  buildInputs = with ourHaskellPackages; [
    ourLatex
    ourPandoc
    ourScons

    codebraid
    librsvg
    pandoc-citeproc_0_16_4_1
  ];

  NIX_PATH = "nixpkgs=${nixpkgs}";
}
