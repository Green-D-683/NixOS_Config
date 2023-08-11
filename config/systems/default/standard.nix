{config, pkgs, ...}:

{
  imports = [
    ../components
    ../programs.core.nix
    ../users/daniel.nix
  ];
}