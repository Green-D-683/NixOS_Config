{config, lib, self, ...}:
let enableSops = config.systemConfig.sops.enable; in
{
    options.systemConfig.sops = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable SOPS for this System";
        };
        sopsDir = lib.mkOption {
            type = lib.types.path;
            default = "${self.outPath}/sops/system";
        };
    };

    config = lib.mkIf enableSops {
        sops = {
            age.keyFile = "/etc/sops/system-key.txt";
        };
    };
}
