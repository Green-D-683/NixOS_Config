{
    config,
    lib,
    ...
}: {
    config = lib.mkIf (builtins.elem "docker" config.systemConfig.virtualisationTools) {
        virtualisation.podman = {
            enable = true;
            dockerCompat = true;
        };
    };
}
