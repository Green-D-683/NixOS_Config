{config, pkgs, lib, inputs, system, ...}:
let
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
    services.xserver.displayManager.setupCommands=''
    screenPadOff
    '';
    environment.systemPackages = with pkgs; [
      toggle-screenpad
    ];

    boot.extraModulePackages = screenpad-driver-package config.boot.kernelPackages.kernel;
    boot.kernelModules = [
      "asus-wmi-screenpad"
    ];
  };
}