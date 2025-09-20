{config, pkgs, lib, ...}:
{
  config = lib.mkIf (config.systemConfig.gpu == "nvidia") {
    boot = {
        # kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=0" ];
        extraModprobeConfig = ''
          options nvidia_modeset vblank_sem_control=0
        '';
    };

    hardware.nvidia={
      nvidiaSettings = true;
      powerManagement = {
        enable = true;
        #finegrained = true;
      };
      package=config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "575.64.05";
          sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
          sha256_aarch64 = "sha256-GRE9VEEosbY7TL4HPFoyo0Ac5jgBHsZg9sBKJ4BLhsA=";
          openSha256 = "sha256-mcbMVEyRxNyRrohgwWNylu45vIqF+flKHnmt47R//KU=";
          settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
          persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";
        };
      open = true;
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

    environment.sessionVariables = {
      KWIN_DRM_ALLOW_NVIDIA_COLORSPACE = 1;
    };
  };
}
