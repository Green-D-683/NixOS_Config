{config, pkgs, lib, ...}:

{
  imports = lib.mkMerge [
    (with .../components/general; [
      /base-config.nix
      /graphical.nix
      /networking.nix
      /bluetooth.nix
      /sound.nix
      /printing.nix
    ])
    ([
      .../programs.core.nix
      .../users/daniel.nix
    ])
  ];
}