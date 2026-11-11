# There isn't actually any secrets here, don't bother looking...
{pkgs, ...}: {
    config.security = {
        wrappers.btop = {
            source = "${pkgs.btop}/bin/btop";
            capabilities = "cap_perfmon+ep";
            owner = "root";
            group = "root";
        };
    };
}
