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
  config.services.xserver.videoDrivers = ["nvidia"];
  config.hardware.nvidia={
    modesetting.enable = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
    ## Example Specification of PCI bus IDs
    # intelBusId = "PCI:0:2:0";
    # nvidiaBusId = "PCI:1:0:0";
    nvidiaSettings = true;
    powerManagement.enable = true;
  };
  
  config.environment.systemPackages = lib.mkIf config.hardware.nvidia.prime.offload.enable [ nvidia-offload ];
}