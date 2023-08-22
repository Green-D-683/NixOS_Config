{config, pkgs, lib, ...}:

{
  imports=[
    ../default/full.nix
    .../components/general/laptop.nix
    .../components/specific/asus/battery.nix
    .../components/specific/asus/screenpad.nix
    .../components/specific/nvidia/offload.nix
  ];

  ## Setting Battery Charge Limit to 90%
  config.hardware.asus.battery={
    chargeUpto = 90;
    enableChargeUptoScript = true;
  };

  ## Denoting Graphics Adapters 
  config.hardware.nvidia.prime={
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  config.networking.hostname = "UnknownDevice_ux535"; # Define your hostname.

}