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
  config= lib.mkIf (builtins.elem "screenpad" config.systemConfig.extraHardware ) {
    services.displayManager.sddm.setupCommands=(builtins.readFile ./noScreenPad-sddm.sh);
    environment.systemPackages= [
      toggle-screenpad
    ];
    
    boot.extraModulePackages = screenpad-driver-package config.boot.kernelPackages.kernel;
    boot.kernelModules = [
      "asus-wmi-screenpad"
    ];
  };
}