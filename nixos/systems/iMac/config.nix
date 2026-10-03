{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = {
    systemConfig = {
      laptop = false;
      desktop = true;
      server = false;
      gpu = "amd";
      extraHardware = [
        # "thunderbolt"
        # "screenpad"
        # "asus-battery"
        # "rpi4"
      ];
      hostname = "UnknowniMac";
      swapSize = 48;
      virtualisationTools = [
        # "docker"
        # "waydroid"
        # "virtualbox"
      ];
      servers = {
        # enable = true;
        # ap = {};
        # router = {};
        # basic = [
        #   "pihole"
        # ]
      };
      niceties.enableFlatpak = true;
    };
    userConfig = {
      users = [
        "daniel"
        "ffion"
      ];

      userModules = {
        daniel = {
          install-lists = [
            "core_utils"
            # "core_gui"
            "general"
          ];
          gui = true;
        };
        ffion = {
          install-lists = [
            "core_utils"
            # "core_gui"
            "general"
          ];
          gui = true;
        };
      };
    };
  };
}
