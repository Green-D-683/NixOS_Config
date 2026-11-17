{
    config,
    lib,
    pkgs,
    ...
}: {
    config = {
        # Enable networking
        networking = {};

        services = {
            dbus = {
                packages = lib.optionals (config.services.strongswan.enable) [pkgs.strongswanNM];
                enable = true;
            };

            xl2tpd.enable = true;
            # strongswan.enable = true;
            # strongswan.secrets = [
            #     "ipsec.d/ipsec.nm-l2tp.secrets"
            # ];
            libreswan = {
                enable = true;
            };
        };

        security.pki.certificateFiles = ["${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
    };
}
