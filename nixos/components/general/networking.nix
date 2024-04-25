{config, lib, pkgs, ...}:

{
  config={
    # Enable networking
    networking={
      networkmanager={
        enable = true;
        enableStrongSwan = true;
      };
      hostName = lib.mkDefault "UnknownDevice-NixOS";
    };

  };
}