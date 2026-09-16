{config, lib, self, ...}:
{
    options.sopsDir = lib.mkOption {
        type = lib.types.path;
        default = "${self.outPath}/sops/system";
    };

    config = {
        sops = {
            age.keyFile = "/etc/sops/system-key.txt";
        };
    };
}
