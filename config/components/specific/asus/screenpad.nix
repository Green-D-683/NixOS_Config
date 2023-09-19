{config, pkgs, lib, ...}:
let
toggle-screenpad = pkgs.writeScriptBin "toggle-screenpad" ''
#!/usr/bin/env bash

disabled="$(kscreen-doctor -o | grep "HDMI-A-2" | egrep -o "disabled")"

if [ $disabled = "disabled" ]
then 
kscreen-doctor output.HDMI-A-2.enable output.HDMI-A-2.mode.0 output.HDMI-A-2.rotation.right output.HDMI-A-2.scale.2 output.HDMI-A-2.position.420,1080
else
kscreen-doctor output.HDMI-A-2.disable
fi
''

{
  # Screenpad SDDM
  #config.services.xserver.displayManager.setupCommands="${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 3840x2160 --output HDMI-A-2 --off";
  #config.services.xserver.displayManager.setupCommands="kscreen-doctor output.HDMI-A-2.disable";
  config={
    services.xserver={
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
    environment.systemPackages=[
      toggle-screenpad
    ];
  };
}