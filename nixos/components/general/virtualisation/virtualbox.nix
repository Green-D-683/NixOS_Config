{
    config,
    pkgs,
    lib,
    ...
}: {
    config = lib.mkIf (builtins.elem "virtualbox" config.systemConfig.virtualisationTools) {
        virtualisation.virtualbox = {
            host = {
                enable = true;
                enableExtensionPack = true;
                # enableKvm = true;
                # addNetworkInterface = false;
            };
        };
        boot = {
            kernelParams = ["kvm.enable_virt_at_load=0"];
            # Virtualbox lags behind kernel releases, so use stable kernel
            kernelPackages = lib.mkForce pkgs.linuxPackages;
        };
    };
}
