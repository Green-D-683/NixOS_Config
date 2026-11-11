{
    config,
    lib,
    ...
}: {
    options = let
        mkOption = lib.mkOption;
        types = lib.types;
    in {
        systemConfig = {
            swapSize = mkOption {
                default = 0;
                type = types.int;
                description = "Size of `/.swapfile`";
            };
        };
    };
    config = {
        # Swap
        zramSwap = {
            enable = true;
            priority = 5;
        };
        swapDevices = lib.optionals (config.systemConfig.swapSize > 0) [
            {
                device = "/.swapfile";
                size = lib.mkDefault (config.systemConfig.swapSize * 1024); # Size given in GiB
                priority = 4;
            }
        ];
    };
}
