{
    config,
    pkgs,
    lib,
    ...
}: {
    options = let
        mkEnableOption = lib.mkEnableOption;
    in {
        systemConfig = {
            niceties = {
                enableEmojiFont = mkEnableOption "Add WhatsApp Emoji Font to `fonts.packages`";
            };
        };
    };
    config = lib.mkIf (config.systemConfig.graphicalEnv) {
        fonts = {
            enableDefaultPackages = true;
            packages = with pkgs;
                [
                    corefonts
                    open-fonts
                ]
                ++ (lib.optional (config.systemConfig.niceties.enableEmojiFont) whatsapp-emoji-font);
            fontDir.enable = true;
            fontconfig.useEmbeddedBitmaps = true;
        };

        # Mount fonts in the correct place
        system.fsPackages = [pkgs.bindfs];

        # Bind-mount Fonts in FHS path to increase compatibility
        fileSystems = let
            mkRoSymBind = path: {
                device = path;
                fsType = "fuse.bindfs";
                options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
            };
            aggregated = pkgs.callPackage (
                {
                    runCommand,
                    gzip,
                    mkfontscale,
                }:
                    runCommand "system-fonts" {
                        preferLocalBuild = true;
                        nativeBuildInputs = [
                            gzip
                            mkfontscale
                        ];
                    }
                    ''
                        mkdir -p "$out/share/fonts"
                        font_regexp='.*\.\(ttf\|ttc\|otb\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
                        find ${toString config.fonts.packages} -regex "$font_regexp" \
                          -exec ln -sf -t "$out/share/fonts" '{}' \;
                        cd "$out/share/fonts"
                        gunzip -f *.gz
                        mkfontscale
                        mkfontdir
                        cat $(find ${pkgs.font-alias}/ -name fonts.alias) >fonts.alias
                    ''
            ) {};
        in {
            "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
        };
    };
}
