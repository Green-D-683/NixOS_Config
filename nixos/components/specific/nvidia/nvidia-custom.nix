{config, pkgs, lib, ...}:
{
  config = lib.mkIf (config.systemConfig.gpu == "nvidia") {
    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

    hardware.nvidia={
      nvidiaSettings = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      package=config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # Suspend Then Hibernate
    systemd.services = let package = config.hardware.nvidia.package; in {
      nvidia-resume = {
        after = ["systemd-suspend-then-hibernate.service"];
        requiredBy = ["systemd-suspend-then-hibernate.service"];
      };
      nvidia-suspend-then-hibernate = {
        description = "NVIDIA system suspend-then-hibernate actions";
        path = [ pkgs.kbd ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${package.out}/bin/nvidia-sleep.sh 'hibernate'";
        };
        before = [ "systemd-suspend-then-hibernate.service" ];
        requiredBy = [ "systemd-suspend-then-hibernate.service" ];
      };
    };
  };
}