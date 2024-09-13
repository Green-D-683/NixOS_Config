{config, pkgs, lib, ...}:
{
  config = lib.mkIf (config.systemConfig.gpu == "nvidia") {
    hardware.nvidia={
      nvidiaSettings = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      package=config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}