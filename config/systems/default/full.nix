{config, pkgs, ...}:

{
  imports = [
    ../components
    ../programs
    ../users/daniel.nix
  ];
}