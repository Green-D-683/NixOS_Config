{config, pkgs, ...}:

{
  imports = [
    ../../components/base-config.nix
    ../../users/daniel.nix
  ];
}