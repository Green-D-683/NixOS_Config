{config, pkgs, lib, ...}:
let 
  updater = pkgs.writeScriptBin "update" "sudo nixos-rebuild switch --flake github:Lordraven19/NixOS_Config#UnknownDevice_ux535 --option tarball-ttl 0";

in
{
  imports=[
    ../../default/full.nix
    ../../../components/general/laptop.nix
    ../../../components/specific/asus/battery.nix
    ../../../components/specific/asus/screenpad.nix
    ../../../components/specific/nvidia/offload.nix
    ./hardware-configuration.nix
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

  config.networking.hostName = "UnknownDevice"; # Define your hostname.

  config.environment.systemPackages=[updater];

}