{
    config,
    lib,
    ...
}: {
    config = lib.mkIf (builtins.elem "docker" config.systemConfig.virtualisationTools) {
        podman = {
            enable = true;
            dockerCompat = true;
        };
    };
}
