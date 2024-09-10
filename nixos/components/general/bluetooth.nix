{config, pkgs, lib, ...}:

{
  # Enable Bluetooth
  config.hardware.bluetooth= lib.mkIf (config.systemConfig.optimiseFor != "server") {
    enable = true;
    powerOnBoot = true;
  };
}