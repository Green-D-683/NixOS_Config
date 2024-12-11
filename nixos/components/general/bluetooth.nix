{config, pkgs, lib, ...}:

{
  # Enable Bluetooth
  config.hardware.bluetooth= lib.mkIf (config.systemConfig.optimiseFor != "server") {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        UserspaceHID = false;
        #ControllerMode = "le";
        #Experimental = true;
      };
    };
  };
}