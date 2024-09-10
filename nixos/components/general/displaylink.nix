{config, pkgs, lib, ...}:

{ ## TODO - This doesn't build
  config = lib.mkIf (builtins.elem "displaylink" config.systemConfig.extraHardware) {
    services.xserver = {
      videoDrivers = [
        "displaylink"
        "modeseting"
      ];
      displayManager.sessionCommands = ''
        ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
      '';
    };
    environment.systemPackages = [pkgs.displaylink];
  };
}