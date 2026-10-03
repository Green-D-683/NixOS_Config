# There isn't actually any secrets here, don't bother looking...
{pkgs, ...}:
{
    config.security = {
        krb5 = {
            enable = true;
            settings = {
                libdefaults = {
                    canonicalization = "true";
                    rdns = "false";
                };
            };
        };
        wrappers.btop = {
          source = "${pkgs.btop}/bin/btop";
          capabilities = "cap_perfmon+ep";
          owner = "root";
          group = "root";
        };
    };
}
