{config, pkgs, lib, ...}:

{
  imports = [
    ../../default
    #./hardware-configuration.nix
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
      hostname = "UnknownDevice";
    };
    userConfig = {
      users = [
        "daniel"
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
      };
    };
  };

}