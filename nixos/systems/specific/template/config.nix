{config, pkgs, lib, ...}:

{
  imports = [
    ../../default
    ./hardware-configuration.nix
  ];

  config = {
    systemConfig = {
      laptop = true;
      gpu = "nvidia";
      extraHardware = [
        # "thunderbolt"
        # "screenpad"
        # "asus-battery"
      ];
      hostname = "UnknownDevice";
      specialConfig = {
        # hardware = {
        #   asus.battery = {
        #     chargeUpto = 90;
        #     enableChargeUptoScript = true;
        #   };
        #   nvidia.prime={
        #     intelBusId = "PCI:0:2:0";
        #     nvidiaBusId = "PCI:1:0:0";
        #   };
        # };
      };
    };
    userConfig = {
      users = [
        "daniel"
      ];
    };
  };

}