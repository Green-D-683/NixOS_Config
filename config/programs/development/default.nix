{config, pkgs, ...}:

{
  imports = [
    ./java.nix
    ./python.nix
    ./sql.nix
    ./ocaml.nix
  ];
}