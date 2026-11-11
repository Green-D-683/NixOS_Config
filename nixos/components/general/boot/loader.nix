{
    config,
    lib,
    ...
}: let
    # Defined for clarity here - add more/adjust as needed
    isRasPi4 = builtins.elem "rpi4" config.systemConfig.extraHardware;
    useSystemDBoot = !isRasPi4;
in {
    config = lib.mkIf (!config.isISO) {
        boot = {
            # Bootloader
            loader = lib.mkMerge [
                {
                    efi.canTouchEfiVariables = true;
                }
                # Raspberry Pi 4 Specific Bootloader
                (lib.mkIf isRasPi4
                    {
                        systemd-boot.enable = false;
                        generic-extlinux-compatible.enable = true;
                    })
                # Otherwise use SystemD-Boot
                (lib.mkIf useSystemDBoot {
                    systemd-boot.enable = lib.mkDefault true;
                })
            ];

            # Stage 1
            initrd = {
                systemd = lib.mkMerge [
                    {
                        enable = true;
                    }
                    (lib.mkIf isRasPi4 {
                        # Raspi 4 Boards don't have TPM
                        tpm2.enable = false;
                    })
                ];
                kernelModules = [
                    "psmouse"
                    "hid_multitouch"
                ];
            };
        };
    };
}
