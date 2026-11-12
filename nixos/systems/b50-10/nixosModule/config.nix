{
    config,
    pkgs,
    lib,
    ...
}: {
    config = {
        systemConfig = {
            laptop = true;
            graphicalEnv = true;
            gpu = "intel";
            extraHardware = [
                # "thunderbolt"
                # "screenpad"
                # "asus-battery"
            ];
            hostname = "AnotherUnknownDevice";
            swapSize = 16;
            virtualisationTools = [
                "docker"
                # "waydroid"
                # "virtualbox"
                "distrobox"
            ];
            niceties.enableFlatpak = true;
        };
        userConfig = {
            users = [
                "daniel"
            ];
            userModules = {
                daniel = {
                    install-lists = [
                        "core_utils"
                        "core_gui"
                        "devkit"
                        "general"
                    ];
                    gui = true;
                };
            };
        };
    };
}
