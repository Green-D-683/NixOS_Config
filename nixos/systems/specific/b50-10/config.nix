{config, pkgs, lib, ...}:

{
  imports = [
    ../../default
    ./hardware-configuration.nix
  ];

  config = {
    systemConfig = {
      laptop = true;
	    graphicalEnv = true;
      gpu = "intel";
      extraHardware = [
        # "thunderbolt"
        # "screenpad"
        # "asus-battery"
      ];
      hostname = "AnotherUnknownDevice";
      swapSize = 16;
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
