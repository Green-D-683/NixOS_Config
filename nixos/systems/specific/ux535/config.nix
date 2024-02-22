{config, pkgs, lib, ...}:
let 
  rebuilder = pkgs.writeScriptBin "rebuild" ''
  sudo nixos-rebuild boot --flake github:Lordraven19/NixOS_Config#Shells_ux535 --option tarball-ttl 0 --no-write-lock-file --profile-name shell_preserve
  sudo nixos-rebuild switch --flake github:Lordraven19/NixOS_Config#UnknownDevice_ux535 --option tarball-ttl 0 --no-write-lock-file
  
  '';

  upgrader = pkgs.writeScriptBin "upgrade" ''
  sudo nixos-rebuild boot --flake github:Lordraven19/Nixos_Config#Shells_ux535 --option tarball-ttl 0 --no-write-lock-file --upgrade --profile-name shell_preserve
  sudo nixos-rebuild switch --flake github:Lordraven19/NixOS_Config#UnknownDevice_ux535 --option tarball-ttl 0 --no-write-lock-file --upgrade
  '';
in
{
  imports=[
    ../../default/full.nix
    ../../../components/general/laptop.nix
    # ../../../components/general/displaylink.nix
    ../../../components/general/thunderbolt.nix
    ../../../components/specific/asus/battery.nix
    ../../../components/specific/asus/screenpad.nix
    ../../../components/specific/asus/asusd.nix
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

  config.environment.systemPackages=[
    rebuilder
    upgrader
    ];

}