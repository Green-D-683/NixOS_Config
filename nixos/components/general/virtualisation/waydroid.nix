{
    config,
    lib,
    ...
}: {
    config = lib.mkIf (builtins.elem "waydroid" config.systemConfig.virtualisationTools) {
        virtualisation.waydroid.enable = true;
    };
}
