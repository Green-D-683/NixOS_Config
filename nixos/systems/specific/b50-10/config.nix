{config, pkgs, lib, ...}:

{
  imports = [
    ../../default
    ./hardware-configuration.nix
  ];

  config = {
    systemConfig = {
      laptop = true;
      gpu = "intel";
      extraHardware = [
        # "thunderbolt"
        # "screenpad"
        # "asus-battery"
      ];
      hostname = "AnotherUnknownDevice";
    };
    userConfig = {
      users = [
        "daniel"
      ];
      userModules = {
        daniel = {
          install-lists = [
            "core_utils"
            "core_gui"
            "devkit"
            "general"
          ];
        };
      };
    };
  };

}