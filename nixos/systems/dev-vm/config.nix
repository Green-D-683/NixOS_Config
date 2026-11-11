{
    config,
    pkgs,
    lib,
    ...
}: {
    config = {
        systemConfig = {
            laptop = false;
            desktop = false;
            server = true;
            gpu = "";
            extraHardware = [
                # "thunderbolt"
                # "screenpad"
                # "asus-battery"
                # "rpi4"
            ];
            hostname = "UnknownDevice";
            swapSize = 0;
            virtualisationTools = [
                # "docker"
                # "waydroid"
                # "virtualbox"
            ];
            servers = {
                enable = true;
                # ap = {};
                # router = {};
                # basic = [
                #   "pihole"
                # ]
            };
            sops.enable = false;
        };
        userConfig = {
            users = [
                "daniel"
            ];
            userModules.daniel = {
                enableSops = false;
            };
        };

        # Use the GRUB 2 boot loader.
        boot.loader.grub = {
            enable = true;
            device = "/dev/vda";
            useOSProber = true;
        };
        boot.loader.systemd-boot.enable = lib.mkForce false;
    };
}
