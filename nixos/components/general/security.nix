# There isn't actually any secrets here, don't bother looking...
{...}:
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
    };
}
