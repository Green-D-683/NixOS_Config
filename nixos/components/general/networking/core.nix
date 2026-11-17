{
    config,
    lib,
    pkgs,
    ...
}: {
    options = let
        mkOption = lib.mkOption;
        types = lib.types;
    in {
        ## Network Hostname
        systemConfig.hostname = mkOption {
            default = "UnknownDevice";
            type = types.str;
            description = "Hostname for Network connections";
        };
    };

    config = {
        # Enable networking
        networking = {
            firewall = let
                ports = lib.optionals (config.systemConfig.graphicalEnv) [
                    # rQuickShare
                    49999
                ];
            in {
                allowedTCPPorts = ports;
                allowedUDPPorts = ports;
            };

            hostName = config.systemConfig.hostname;
        };
    };
}
