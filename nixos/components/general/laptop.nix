{config, pkgs, lib, ...}:

{
  config= lib.mkIf (config.systemConfig.optimiseFor == "laptop") {
    # ThermalD - prevents overheating
    services.thermald.enable = true;

    # # TLP - Power Management
    # services.tlp.enable=true;
  };
}