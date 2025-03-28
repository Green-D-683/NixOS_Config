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
      swapSize = 0;
      virtualisationTools = [
        # "docker"
        # "waydroid"
        # "virtualbox"
      ];
      servers = [
        # "pihole"
        "ap"
      ];
    };
    userConfig = {
      users = [
        "daniel"
      ];
    };
    ## Custom Extra Config:
    hardware = {
      raspberry-pi."4" = {
        apply-overlays-dtmerge.enable = true;
        bluetooth.enable=true;
        fkms-3d = {
          enable = true;
          cma = 512;
        };
      };
    };
    console.enable = false;
    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    networking.networkmanager.wifi.powersave = false;
  };
}