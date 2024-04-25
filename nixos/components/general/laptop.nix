{config, pkgs, ...}:

{
  config={
    # ThermalD - prevents overheating
    services.thermald.enable = true;

    # # TLP - Power Management
    # services.tlp.enable=true;
  };
}