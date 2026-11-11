{
    config,
    pkgs,
    lib,
    ...
}: {
    config = lib.mkIf (config.systemConfig.optimiseFor != "server") {
        # Enable sound with pipewire.
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            audio.enable = true;
            wireplumber.enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };
    };
}
