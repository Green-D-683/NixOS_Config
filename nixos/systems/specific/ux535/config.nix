{inputs, config, pkgs, lib, ...}:

{
  imports = [
    ../../default
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
    };
    userConfig = {
      users = [
        "daniel"
        "ciccu"
      ];
    };

  hardware = {
    asus.battery = {
      chargeUpto = 90;
      enableChargeUptoScript = true;
    };
  };
  };

}