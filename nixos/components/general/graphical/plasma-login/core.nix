{
    config,
    pkgs,
    lib,
    ...
}: {
    config = lib.mkIf (config.systemConfig.graphicalEnv) {
        services = {
            displayManager = {
                plasma-login-manager = {
                    enable = true;
                    settings = {
                    };
                    applyCustomTheme = true;
                };
                defaultSession = "plasma";
            };
        };
    };
}
