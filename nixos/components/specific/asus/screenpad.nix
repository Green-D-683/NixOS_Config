{config, pkgs, lib, ...}:
let
screenpadPort = "HDMI-A-2";
toggle-screenpad = pkgs.writeScriptBin "toggle-screenpad" (builtins.readFile ./Toggle-Screenpad.sh);
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
      displayManager.setupCommands=(builtins.readFile ./noScreenPad-sddm.sh);
      # xrandrHeads = [
      #   {
      #     output = "eDP-1";
      #     primary = true;
      #   }
      #   {
      #     output = "HDMI-A-2";
      #     monitorConfig = ''Option "Enable" "false"'';
      #   }
      # ];
    };
    environment.systemPackages=[
      toggle-screenpad
      pkgs.wlr-randr
    ];
  };
}