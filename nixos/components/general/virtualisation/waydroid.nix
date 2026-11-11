{
    config,
    lib,
    ...
}: {
    config = lib.mkIf (builtins.elem "waydroid" config.systemConfig.virtualisationTools) {
        waydroid.enable = true;
    };
}
