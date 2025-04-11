{inputs, config, pkgs, lib, ...}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.asus-zenbook-ux535
  ];

  config = {
    systemConfig = {
      laptop = true;
      graphicalEnv = true;
      gpu = "nvidia";
      extraHardware = [
        "thunderbolt"
        "screenpad"
      ];
      hostname = "UnknownDevice";
      swapSize = 32;
      virtualisationTools = [
        "docker"
        # "waydroid"
        "virtualbox"
      ];
    };
    userConfig = {
      users = [
        "daniel"
        "ciccu"
      ];

      userModules = {
        daniel = {
          install-lists = [
            "core_utils"
            "cad"
            "ciccu"
            "core_gui"
            "devkit"
            "gaming"
            "general"
          ];
        };
        ciccu = {
          install-lists = [
            "ciccu"
          ];
        };
      };
    };

  hardware = {
    asus.battery = {
      chargeUpto = 90;
      enableChargeUptoScript = true;
    };
  };
  };

}