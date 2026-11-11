{
    config,
    pkgs,
    lib,
    ...
}: {
    config = lib.mkIf (config.systemConfig.graphicalEnv) {
        environment.systemPackages = [
            pkgs.gnome-network-displays
        ];
        ## Ports for MiraCast
        networking.firewall = {
            allowedTCPPorts = [17500 7236 7250];
            allowedUDPPorts = [17500 7236 7250];
        };
        programs = {
            # Allowing GTK theming
            dconf.enable = true;
            # Kde connect
            kdeconnect = {
                enable = true;
                package = lib.mkForce pkgs.kdeConnect;
            };
            # Kde partition manager
            partition-manager.enable = true;
        };
    };
}
