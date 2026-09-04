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
        # "virtualbox"
        "distrobox"
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

    # Bind TTY4 to external displays
    systemd.services.con2fbmap-setup = {
      description = "Map TTY4 to External Monitor Framebuffer";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.fbset}/bin/con2fbmap 4 1";
      };
    };
  };

}
