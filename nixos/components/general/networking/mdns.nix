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
                    5353
                    53791
                ];
            in {
                allowedTCPPorts = ports;
                allowedUDPPorts = ports;
            };
        };
        services = {
            # Avahi implements mDNS Responses
            avahi = {
                enable = true;
                nssmdns4 = false;
                nssmdns6 = false;
                openFirewall = true;
                wideArea = false; # Insecure
                settings = {
                    server = {
                        use-ipv4 = true;
                    };
                    publish = {
                        publish-addresses = true;
                        publish-domain = true;
                        publish-hinfo = true;
                        publish-workstation = true;
                    };
                    reflector = {
                        enable-reflector = true;
                    };
                };
            };

            # Use systemd-resolved for sending requests
            resolved.enable = true;
        };
    };
}
