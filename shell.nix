{ pkgsHash ? "a4936a77b5487b0233c470a09576a974b0b24934" }:

let
  nixpkgs = builtins.fetchTarball
    "https://github.com/NixOS/Nixpkgs/archive/${pkgsHash}.tar.gz";
  pkgs = import nixpkgs { };

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

  #   ourHaskellPackages = haskell.packages.ghc883;
  ourHaskellPackages = haskellPackages;

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
    entr
  ];

  NIX_PATH = "nixpkgs=${nixpkgs}";
}
