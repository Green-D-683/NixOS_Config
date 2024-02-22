{config, pkgs, lib, ...}:
let 
  # components = let path = ../../components/general; in [
  #   (path + "/base-config.nix")
  #   (path + "/graphical.nix")
  #   (path + "/networking.nix")
  #   (path + "/sound.nix")
  #   (path + "/bluetooth.nix")
  #   (path + "/printing.nix")
  #   (path + "/virtualisation.nix")
  # ];
  # programs = let path = ../../programs; in [
  #   (path + "/core.nix")
  #   (path + "/cad.nix")
  #   (path + "/devkit.nix")
  #   (path + "/gaming.nix")
  # ];
  # users = let path = ../../users; in [
  #   (path + "/daniel/daniel.nix")
  # ];

  components = map (x : ../../components/general/${x}.nix) [
    "base-config"
    "graphical"
    "networking"
    "sound"
    "bluetooth"
    "printing"
    "virtualisation"
  ];

  programs = map (x : ../../../pkgs/programs/${x}.nix) [
    "core_gui"
    "cad"
    "devkit"
    "gaming"
    "development"
  ];

  users = map (x : ../../../home/${x}/${x}.nix) [
    "daniel"
  ];
in 

{
  imports = components ++users ++ [../../../pkgs/extra_config.nix];

  # config.environment.systemPackages = builtins.concatLists (map (x : import x {pkgs=pkgs;}) programs);
}