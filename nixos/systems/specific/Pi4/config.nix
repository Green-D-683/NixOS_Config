{inputs, config, pkgs, lib, ...}:

{
  imports = [
    ../../default
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  config = {
    ## Call Declared Modules here:
    systemConfig = {
      server = true;
      gpu = "";
      extraHardware = [
        "rpi4"
      ];
      hostname = "UnknownPi";
      swapSize = 8;
    };
    userConfig = {
      users = [
        "daniel"
      ];
    };
    ## Custom Extra Config:

  };

}