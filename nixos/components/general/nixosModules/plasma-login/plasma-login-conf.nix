{config, pkgs, lib, ...}:
{
    options = {
        services.displayManager.plasma-login-manager = {
            applyCustomTheme = lib.mkEnableOption "Apply Win10 Style Custom Theme to Plasma-login-manager";
            customThemeBackground = lib.mkOption {
                default = "${pkgs.resources}/share/resources/lock.png";
                type = lib.types.path;
                example = lib.literalExpression ''
                    customThemeBackground = ./image.png;
                '';
            };
        };
    };

    config = let cfg = config.services.displayManager.plasma-login-manager; in lib.mkIf (cfg.applyCustomTheme) {
        environment.etc = {
            "plasmalogin.conf.d/98-set-background.conf".text = ''
            [Greeter][Wallpaper][org.kde.image][General]
            Image=file://${cfg.customThemeBackground}
            '';
            "plasmalogin.conf".source = let
            confDirFiles = lib.filterAttrs (n: _: lib.hasPrefix "plasmalogin.conf.d/" n) config.environment.etc;
            orderedFileNames = lib.naturalSort (lib.attrNames confDirFiles);
            sources = map(n: confDirFiles.${n}.source) orderedFileNames;
            merged-conf-dir = pkgs.runCommandLocal "plasmalogin.conf" { } ''
                cat ${lib.concatMapStringsSep " " lib.escapeShellArg sources} > $out
            '';
            in merged-conf-dir;
        };
    };
}
