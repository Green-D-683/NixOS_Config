{config, pkgs, ...}:

{
  imports = [
    ../../components/general/base-config.nix
    ../../../home/daniel/daniel.nix
  ];
}