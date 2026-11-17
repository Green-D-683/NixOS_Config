{
    config,
    lib,
    pkgs,
    ...
}: {
    config = {
        # Enable networking
        networking = {
            firewall = let
                ports = [
                    # Required for Hotspot functionality
                    53
                    67
                ];
            in {
                allowedTCPPorts = ports;
                allowedUDPPorts = ports;
            };

            networkmanager = {
                enable = true;
                connectionConfig.mdns = 2;
                wifi = {
                    powersave = false;
                    backend = "wpa_supplicant";
                };
                plugins = with pkgs; [
                    networkmanager_strongswan
                    networkmanager-openconnect
                    networkmanager-l2tp
                    networkmanager-openvpn
                ];
            };
        };

        services.dbus = {
            packages = [pkgs.networkmanager pkgs.strongswanNM];
            enable = true;
        };

        systemd.services = {
            NetworkManager-wait-online = {
                description = "Network Manager Wait Online";
                documentation = ["man:NetworkManager-wait-online.service(8)"];
                script = "${pkgs.networkmanager}/bin/nm-online -s -q";
                serviceConfig.RemainAfterExit = "yes";
                environment.NM_ONLINE_TIMEOUT = "60";
                wantedBy = ["multi-user.target"];
            };
            NetworkManager-ensure-profiles.script = let
                cfg = config.networking.networkmanager;
            in
                lib.mkIf (cfg.ensureProfiles.profiles != {}) (
                    lib.mkForce (
                        let
                            path = id: "/run/NetworkManager/system-connections/${id}.nmconnection";
                            iniText = v: ''
                                ${lib.generators.toINI {} {connection = v.connection;}}

                                ${lib.generators.toINI {} (lib.filterAttrs (k: _: k != "connection") v)}
                            '';
                            iniFile = n: v: pkgs.writeText n (iniText v);
                        in (
                            ''
                                mkdir -p /run/NetworkManager/system-connections
                            ''
                            + lib.concatMapStringsSep "\n" (profile: ''
                                ${pkgs.envsubst}/bin/envsubst -i ${iniFile (lib.escapeShellArg profile.n) profile.v} > ${path (lib.escapeShellArg profile.n)}
                            '') (lib.mapAttrsToList (n: v: {inherit n v;}) cfg.ensureProfiles.profiles)
                            + ''
                                ${cfg.package}/bin/nmcli connection reload
                            ''
                        )
                    )
                );
        };
    };
}
