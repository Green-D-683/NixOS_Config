{config, pkgs, lib, ...}:

{
  config = {
    systemConfig = {
      laptop = false;
      desktop = false;
      server = true;
      gpu = "";
      extraHardware = [
        # "thunderbolt"
        # "screenpad"
        # "asus-battery"
        # "rpi4"
      ];
      hostname = "UnknownDevice";
      swapSize = 0;
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
    };
    userConfig = {
      users = [
        "daniel"
      ];

      userModules = {
        daniel = {
          install-lists = [
            "core_utils"
            "general"
          ];
        };
      };
    };
  };
}
