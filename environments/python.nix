with import <nixpgks> {};

python3.withPackages
    (p: with p; [ numpy ])
