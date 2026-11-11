{
    config,
    pkgs,
    lib,
    ...
}: {
    options = let
        mkOption = lib.mkOption;
        mkEnableOption = lib.mkEnableOption;
        types = lib.types;
    in {
        systemConfig.niceties.plymouth = {
            theme = mkOption {
                type = types.string;
                default = "darth_vader";
                description = "Plymouth Theme to install and use";
            };
            silentBoot = mkEnableOption "Boot without console output for cleaner look";
        };
    };

    config.boot = lib.mkIf (!config.isISO) (lib.mkMerge [
        {
            plymouth = rec {
                enable = true;
                theme = config.systemConfig.niceties.plymouth.theme;
                themePackages = with pkgs; [
                    # By default this would install all themes
                    (adi1090x-plymouth-themes.override {
                        selected_themes = [theme];
                    })
                ];
            };
        }
        (lib.mkIf config.systemConfig.niceties.plymouth.silentBoot {
            # Enable "Silent boot"
            consoleLogLevel = 3;
            initrd.verbose = false;
            kernelParams = [
                "quiet"
                "splash"
                "boot.shell_on_fail"
                "udev.log_priority=3"
                "rd.systemd.show_status=auto"
            ];
            # Hide the OS choice for bootloaders.
            # It's still possible to open the bootloader list by pressing any key
            # It will just not appear on screen unless a key is pressed
            loader.timeout = 0;
        })
    ]);
}
