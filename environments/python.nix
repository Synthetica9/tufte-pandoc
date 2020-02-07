with import <nixpkgs> {};

python3.withPackages
    (p: with p; [ numpy ])
