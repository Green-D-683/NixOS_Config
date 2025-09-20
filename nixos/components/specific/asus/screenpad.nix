{config, pkgs, lib, inputs, ...}:
let
screenpad-driver-package = (kernelPackage: let asus-wmi-screenpad = inputs.screenpad-driver.defaultPackage.${pkgs.system}.override{kernel=kernelPackage;};
  in [
    asus-wmi-screenpad
  ]
);
in
{
  # Screenpad SDDM
  #config.services.xserver.displayManager.setupCommands="${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 3840x2160 --output ${screenpadPort} --off";
  #config.services.xserver.displayManager.setupCommands="kscreen-doctor output.${screenpadPort}.disable";
    config= lib.mkIf (builtins.elem "screenpad" config.systemConfig.extraHardware ) (let
        screenpadSetup = pkgs.writeScript "setup-screenpad" ''
            #!${pkgs.runtimeShell}
            ${pkgs.coreutils}/bin/chmod a+w /sys/class/leds/$1/brightness
            ${pkgs.coreutils}/bin/echo 0 > /sys/class/leds/$1/brightness
        '';
        screenpadSetupUdev = ''
            # rules for asus_nb_wmi devices
            # make screenpad backlight brightness write-able by everyone
            ACTION=="add", SUBSYSTEM=="leds", KERNEL=="asus::screenpad", RUN+="${screenpadSetup} %k"
        '';
    in {
        services.xserver.displayManager.setupCommands=''
        screenPadOff
        '';
        environment.systemPackages = with pkgs; [
        toggle-screenpad
        ];

        boot = {
            extraModulePackages = screenpad-driver-package config.boot.kernelPackages.kernel;
            kernelModules = [
                "asus-wmi-screenpad"
            ];
            initrd = {
                # systemd.services.setup-screenpad = {
                #     description = "Setup Permissions on Screenpad - and turn off by default";
                #     wantedBy = [
                #     #"initrd.target"
                #     "sysinit.target"
                #     ];
                #     after = [
                #     "sys-fs.target"
                #     ];
                #     before = [
                #     "initrd-root-device.target"
                #     ];
                #     path = with pkgs; [
                #     coreutils
                #     ];
                #     unitConfig.DefaultDependencies = "no";
                #     serviceConfig.Type = "oneshot";
                #     script = ''
                #         chmod a+w "/sys/class/leds/asus::screenpad/brightness"
                #         echo 0 >> "/sys/class/leds/asus::screenpad/brightness"
                #     '';
                # };
                kernelModules = [
			"asus-wmi"
			"asus-wmi-screenpad"
		];
                services.udev.rules = screenpadSetupUdev;
            };
        };
        services.udev.extraRules = screenpadSetupUdev;
    });
}
