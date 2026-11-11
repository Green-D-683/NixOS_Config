{
    config,
    pkgs,
    lib,
    ...
}: {
    config = {
        ## System Upgrades
        system = {
            # TODO Auto system update
            autoUpgrade = {
                enable = false;
                dates = "monthly";
            };
        };
    };
}
