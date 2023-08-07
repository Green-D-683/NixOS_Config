{ config, pkgs, lib, ... }:
let
  p = pkgs.writeScriptBin "charge-upto" ''
    echo ''${0:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
  '';
  cfg = config.hardware.asus.battery;
  nvidia-offload = pkgs.writeScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in

{
  ## Battery Charge Limit to 90%

  options.hardware.asus.battery = {
    chargeUpto = lib.mkOption {
      description = "Maximum level of charge for your battery, as a percentage.";
      default = 100;
      type = lib.types.int;
    };
    enableChargeUptoScript = lib.mkOption {
      description = "Whether to add charge-upto to environment.systemPackages. `charge-upto 75` temporarily sets the charge limit to 75%.";
      default = true;
      type = lib.types.bool;
    };
  };
  config = {
    environment.systemPackages = lib.mkMerge [
      (lib.mkIf cfg.enableChargeUptoScript [ p ])
      (lib.mkIf config.hardware.nvidia.prime.offload.enable [ nvidia-offload ])
      (with pkgs; [
        # Thunderbolt
        thunderbolt
        libsForQt5.plasma-thunderbolt
      ])
    ];
    systemd.services.battery-charge-threshold = {
      wantedBy = [ "local-fs.target" "suspend.target" ];
      after = [ "local-fs.target" "suspend.target" ];
      description = "Set the battery charge threshold to ${toString cfg.chargeUpto}%";
      startLimitBurst = 5;
      startLimitIntervalSec = 1;
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = "${pkgs.runtimeShell} -c 'echo ${toString cfg.chargeUpto} > /sys/class/power_supply/BAT?/charge_control_end_threshold'";
      };
    };
    
  };

  config.hardware.asus.battery.chargeUpto = 90;
  config.hardware.asus.battery.enableChargeUptoScript = true;

  ## Graphics
  config.services.xserver.videoDrivers = ["nvidia"];
  config.hardware.nvidia.modesetting.enable = true;
  config.hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";

  };
  config.hardware.nvidia = {
    nvidiaSettings = true;
  };
  #config.environment.systemPackages = [ nvidia-offload ]; ## Above
  config.hardware.nvidia.powerManagement.enable = true;

  # Thunderbolt - also has packages in environment.systemPackages
  config.services.hardware.bolt.enable=true;


  # Screenpad SDDM
  #config.services.xserver.displayManager.setupCommands="${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 3840x2160 --output HDMI-A-2 --off";
  #config.services.xserver.displayManager.setupCommands="kscreen-doctor output.HDMI-A-2.disable";
  config.services.xserver={
    xrandrHeads=[
      {
        output="eDP-1";
        primary=true;
      }
      {
        output="HDMI-A-2";
        monitorConfig=''Option "Enable" "false"'';
      }
    ];
    exportConfiguration=true;
  };

}


