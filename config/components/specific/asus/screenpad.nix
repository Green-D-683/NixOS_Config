{config, pkgs, lib, ...}:
let
screenpadPort = "HDMI-A-2";
toggle-screenpad = pkgs.writeScriptBin "toggle-screenpad" ''
#!/usr/bin/env bash

disabled="$(kscreen-doctor -o | grep "${screenpadPort}" | egrep -o "disabled")"

if [ $disabled = "disabled" ]
then 
kscreen-doctor output.${screenpadPort}.enable output.${screenpadPort}.mode.0 output.${screenpadPort}.rotation.right output.${screenpadPort}.scale.2 output.${screenpadPort}.position.420,1080
else
kscreen-doctor output.${screenpadPort}.disable
fi
'';
in
{
  # Screenpad SDDM
  #config.services.xserver.displayManager.setupCommands="${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 3840x2160 --output ${screenpadPort} --off";
  #config.services.xserver.displayManager.setupCommands="kscreen-doctor output.${screenpadPort}.disable";
  config={
    services.xserver={
      # xrandrHeads=[
      #   {
      #     output="eDP-1";
      #     primary=true;
      #   }
      #   {
      #     output="${screenpadPort}";
      #     monitorConfig=''Option "Enable" "false"'';
      #   }
      # ];
      exportConfiguration=true;
      displayManager.setupCommands="${lib.getExe pkgs.xorg.xrandr} --output eDP-1 --mode 3840x2160 --primary --output ${screenpadPort} --off";
    };
    environment.systemPackages=[
      toggle-screenpad
      pkgs.wlr-randr
    ];
  };
}