{config, pkgs, lib, ...}:

{
  imports = lib.mkMerge [
    (with .../components/general; [
      /base-config.nix
      /graphical.nix
      /networking.nix
      /sound.nix
      /bluetooth.nix
      /printing.nix
    ]) 
    (with .../programs; [
      /core.nix
      /cad.nix
      /devkit.nix
      /gaming.nix
    ])
    (.../users/daniel.nix)
  ];
}