{
    config,
    pkgs,
    lib,
    ...
}: let
    masterKeyFile = "dg683-KEYS-key";
    sopsCfg = config.systemConfig.sops;
    enableSops = sopsCfg.enable;
in {
    config = lib.mkIf enableSops {
        sops.secrets.${masterKeyFile} = let
            daniel = config.users.users.daniel;
        in {
            format = "binary";
            sopsFile = "${sopsCfg.sopsDir}/key-usb-keyfile.bin";
            owner = daniel.name;
            group = daniel.group;
            mode = "0400";
            path = "/etc/${masterKeyFile}";
        };
        environment.etc = {
            crypttab.text = ''
                keys LABEL=dg683-KEYS /etc/${masterKeyFile} nofail
            '';
        };
        fileSystems = {
            "/keys" = {
                device = "/dev/mapper/keys";
                fsType = "ext4";
                options = lib.mkDefault [
                    "user" # Allows any user to mount and unmount
                    "nofail"
                    "X-mount.owner=daniel"
                    "X-mount.group=daniel"
                ];
            };
        };
    };
}
