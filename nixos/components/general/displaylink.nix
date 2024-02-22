{config, pkgs, lib, ...}:

{ ## TODO - This doesn't build
  config = {
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