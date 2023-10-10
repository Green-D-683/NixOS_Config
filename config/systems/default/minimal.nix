{config, pkgs, ...}:

{
  imports = [
    ../../components/general/base-config.nix
    ../../users/daniel.nix
  ];
}