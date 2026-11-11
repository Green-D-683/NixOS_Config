{
    config,
    pkgs,
    lib,
    ...
}: {
    config = {
        # Firmware
        hardware = {
            enableRedistributableFirmware = true;
            enableAllFirmware = true;
        };

        services.fwupd.enable = true;
    };
}
