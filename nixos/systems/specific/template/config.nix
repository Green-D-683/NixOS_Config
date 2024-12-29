{config, pkgs, lib, ...}:

{
  imports = [
    ../../default
    ./hardware-configuration.nix
  ];

  config = {
    systemConfig = {
      laptop = false;
      desktop = false;
      server = false;
      gpu = "";
      extraHardware = [
        # "thunderbolt"
        # "screenpad"
        # "asus-battery"
        # "rpi4"
      ];
      hostname = "UnknownDevice";
      swapSize = 0;
    };
    userConfig = {
      users = [
        "daniel"
      ];
    };
  };

}