{config, pkgs, lib, ...}:
let
  nvidia-offload = pkgs.writeScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  config = lib.mkIf (config.systemConfig.gpu == "nvidia") { 
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia={
      open = true;
      modesetting.enable = true;
      prime = lib.mkIf (config.systemConfig.optimiseFor == "laptop") {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        reverseSync.enable = true;
      };
      ## Example Specification of PCI bus IDs
      # intelBusId = "PCI:0:2:0";
      # nvidiaBusId = "PCI:1:0:0";
      nvidiaSettings = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      package=config.boot.kernelPackages.nvidiaPackages.beta;
    };
    environment.systemPackages = lib.mkIf config.hardware.nvidia.prime.offload.enable [ nvidia-offload ];
  };
}