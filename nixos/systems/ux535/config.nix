{inputs, config, pkgs, lib, ...}:

{
  imports = [
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
          gui = true;
        };
        ciccu = {
          install-lists = [
            "ciccu"
          ];
          gui = true;
        };
      };
    };

    hardware = {
      asus.battery = {
        chargeUpto = 90;
        enableChargeUptoScript = true;
      };
    };

    # services.kmscon = {
    #   extraConfig = lib.mkForce ''
    #   "font-size=48"
    #   '';
    # };

    # boot.kernelParams = [
    #   # Disable Screenpad in TTY - but also DE
    #   "video=HDMI-A-2:Dd"
    # ];
  };

}
