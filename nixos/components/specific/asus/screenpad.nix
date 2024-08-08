{config, pkgs, lib, inputs, ...}:
let
system = "x86_64-linux";
screenpadPort = "HDMI-A-2";
toggle-screenpad = pkgs.writeScriptBin "toggle-screenpad" (builtins.readFile ./Toggle-Screenpad.sh);
screenpad-driver-package = (kernelPackage: let asus-wmi-screenpad = inputs.screenpad-driver.defaultPackage.${system}.override{kernel=kernelPackage;};
  in [
    asus-wmi-screenpad
  ]
);


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
    environment.systemPackages= [
      toggle-screenpad
      pkgs.wlr-randr
    ];

    ## TODO: Fix this
    # boot.extraModulePackages = screenpad-driver-package config.boot.kernelPackages.kernel;
    # boot.kernelModules = [
    #   "asus-wmi-screenpad"
    # ];
  };
}