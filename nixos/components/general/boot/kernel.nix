{
    config,
    pkgs,
    lib,
    system,
    ...
}: {
    config = lib.mkIf (!config.isISO) {
        kernel = {
            # Swappiness - lower is less aggressive
            sysctl = {"vm.swappiness" = 10;};
        };

        # Using latest kernel
        kernelPackages = (
            if (builtins.elem "rpi4" config.systemConfig.extraHardware)
            then # Raspberry Pi 4 Specific Kernel
                lib.mkForce pkgs.linuxKernel.packages.linux_rpi4
            else if (config.systemConfig.optimiseFor == "laptop")
            then lib.mkDefault pkgs.linuxPackages_latest
            else lib.mkDefault pkgs.linuxPackages_zen
        );

        # Allow emulate common cross-systems
        binfmt.emulatedSystems = lib.lists.remove system [
            "aarch64-linux"
            "x86_64-linux"
        ];
    };
}
