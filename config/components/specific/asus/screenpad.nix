{config, pkgs, lib, ...}:

{
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