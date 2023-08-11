{config, pkgs, ...}:

{
  config={
    # ThermalD - prevents overheating
    services.thermald.enable = true;

    # CPU-autofrequency
    services.auto-cpufreq.enable=true;
  };
}