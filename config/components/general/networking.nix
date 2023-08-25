{config, lib, pkgs, ...}:

{
  config={
    # Enable networking
    networking={
      networkmanager.enable = true;
      hostName = lib.mkDefault "UnknownDevice-NixOS";
    };

  };
}