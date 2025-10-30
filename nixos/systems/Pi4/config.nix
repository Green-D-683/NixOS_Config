{inputs, config, pkgs, lib, ...}:

{
  imports = [
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
      servers = {
        enable = true;
        router = {
          enable = true;
          uplink = {
            enable = true;
            interface = "enp1s0u2";
          };
          downstreamWiFi = {
            enable = true;
            interface = "wlan0";
            ssid = "Unknown";
            password = "EduroamSlow";
          };
          downstreamWired = {
            enable = true;
            interface = "end0";
          };
        };
      };
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

    # boot.blacklistedKernelModules = [ "brcmfmac" ]; # Use USB WiFi adapter only for now
  };
}
