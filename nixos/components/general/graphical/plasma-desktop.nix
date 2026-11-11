{
    config,
    pkgs,
    lib,
    ...
}: {
    config = lib.mkIf (config.systemConfig.graphicalEnv) {
        services = {
            desktopManager = {
                # Enable KDE Plasma
                plasma6 = {
                    enable = true;
                    enableQt5Integration = true;
                };
            };
        };
        # Remove Unnecessary Plasma Programs
        environment = {
            plasma6.excludePackages = with pkgs.kdePackages; [
                kate
                elisa
            ];

            sessionVariables = {
                NIXOS_OZONE_WL = 1; # Wayland webapps
                MOZ_ENABLE_WAYLAND = 1; # Firefox Wayland
                MOZ_WEBRENDER = 1;
                KWIN_DRM_ALLOW_INTEL_COLORSPACE = 1;
                KWIN_FORCE_ASSUME_HDR_SUPPORT = 1;
            };
        };
    };
}
