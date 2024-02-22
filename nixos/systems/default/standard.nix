{config, pkgs, lib, ...}:
let 
  components = map (x : ../../components/general/${x}.nix) [
    "base-config"
    "graphical"
    "networking"
    "sound"
    "bluetooth"
    "printing"
  ];

  programs = map (x : ../../../pkgs/programs/${x}.nix) [
    "core_gui"
  ];

  users = map (x : ../../../home/${x}/${x}.nix) [
    "daniel"
  ];
{
  imports = components ++ users ++ [../../../pkgs/extra_config.nix];

  # config.environment.systemPackages = builtins.concatLists (map (x : import x {pkgs=pkgs}) programs);
}